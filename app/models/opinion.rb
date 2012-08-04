# == Schema Information
#
# Table name: opinions
#
#  id           :integer          not null, primary key
#  action       :string(255)
#  creator_id   :integer
#  score_change :integer
#  target_id    :integer
#  target_type  :integer
#  to_flag      :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Opinion < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :target, :polymorphic => true

  scope :of, lambda{ |user| where(:creator_id => user.id)}
  scope :upvote, where(:action => "upvote")
  scope :downvote, where(:action => "downvote")
  scope :flag, where(:action => "flag")
  scope :for_question, where(:target_type => "Question")
  scope :for_answer, where(:target_type => "Answer")
  scope :for_comment, where(:target_type => "Comment")
  scope :that_affect, lambda{ |user| where(:target => {:creator_id => user.id})}

end
