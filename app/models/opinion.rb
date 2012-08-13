# == Schema Information
#
# Table name: opinions
#
#  id           :integer          not null, primary key
#  optype       :string(255)      not null
#  creator_id   :integer          not null
#  score_change :integer          not null
#  target_id    :integer          not null
#  target_type  :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Opinion < ActiveRecord::Base
  attr_accessible :score_change, :optype, :target_id, :target_type

  belongs_to :creator, :class_name => "User"
  belongs_to :target, :polymorphic => true

  #before_save :save_reputation

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

  # def determine_score_change()
  #
  # end
  #
  # def save_reputation()
  #   score_change = determine_score_change
  #   creator.reputation += score_change
  #   creator.save
  # end
end
