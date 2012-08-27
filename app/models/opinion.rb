# == Schema Information
#
# Table name: opinions
#
#  id           :integer          not null, primary key
#  optype       :string(255)      not null
#  creator_id   :integer          not null
#  target_id    :integer          not null
#  target_type  :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Opinion < ActiveRecord::Base
  attr_accessible :optype, :target_id, :target_type, :creator, :target
  before_save :pre_save
  after_save :post_save
  validate :disallow_self_vote
  belongs_to :creator, :class_name => "User"
  belongs_to :target, :polymorphic => true

  scope :by, lambda{ |user| where(:creator_id => user.id)}
  scope :upvote, where(:optype => "upvote")
  scope :downvote, where(:optype => "downvote")
  scope :flag, where(:optype => "flag")
  scope :for, lambda{ |target|
    where("target_id = ? and target_type = ?",target.id, target.class.name)
  }
  scope :for_question, where(:target_type => "Question")
  scope :for_answer, where(:target_type => "Answer")
  scope :for_comment, where(:target_type => "Comment")
  scope :that_affect, lambda{ |user| where(:target => {:creator_id => user.id})}

  validate :optype, :inclusion => {
    :in => ["upvote", "downvote", "flag"]
  }

  has_many :activities, :as => :subject

  def removes_upvote?
      not created_at_changed? and optype_was == "upvote"
  end

  def removes_downvote?
      not created_at_changed? and optype_was == "downvote"
  end

  def adds_upvote?
      optype == "upvote"
  end

  def adds_downvote?
      optype == "downvote"
  end

  def pre_save
    return true unless optype_changed?
    return false unless valid?
    target.upvote_count -= 1 if removes_upvote?
    target.downvote_count -= 1 if removes_downvote?
    target.upvote_count += 1 if adds_upvote?
    target.downvote_count += 1 if adds_downvote?

    # change reputations:
    # --
    # Reputation scheme almost identical to that of stack overflow.
    # Ref : http://meta.stackoverflow.com/questions/7237/how-does-reputation-work
    if removes_downvote?
      target.creator.reputation += 2
      creator.reputation += 1
    end

    if adds_downvote?
      target.creator.reputation -= 2
      creator.reputation -= 1
    end

    if target.instance_of? Question
      if adds_upvote? then target.creator.reputation += 5 end
      if removes_upvote? then target.creator.reputation -= 5 end
    elsif target.instance_of? Answer
      if adds_upvote? then target.creator.reputation += 10 end
      if removes_upvote? then target.creator.reputation -= 10 end
    end

    target.creator.reputation = 1 if target.creator.reputation < 1
    creator.reputation = 1 if creator.reputation < 1

    @activity = Activity.new
    @activity.description = optype + "d"
    @activity.save

    [target.creator, creator].each do |u|
      if u.reputation_changed?
        rep = ReputationChange.new
        rep.user = u
        rep.activity = @activity
        rep.save

        n = Notification.new
        n.user = target.creator
        n.activity = @activity
        n.save

        u.save
      end
    end
    true
  end

  def post_save
    @activity.subject = self
    @activity.save
  end

  def disallow_self_vote
    if creator.id == target.creator.id
      errors.add(:target, "You can not vote for yourself")
    end
  end

  def get_summary
    self
  end
end
