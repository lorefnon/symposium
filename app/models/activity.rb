# == Schema Information
#
# Table name: activities
#
#  id           :integer          not null, primary key
#  subject_id   :integer
#  subject_type :integer
#  initiator_id :integer
#  description  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# An Activity instance corresponds to some activity performed
# by a user eg. creation of Question, creation of Answer, etc,
#
# Note: current message generator assumes desc to be a verb in
# past tense eg. created, deleted etc.
class Activity < ActiveRecord::Base
  attr_accessible :subject, :description, :concerned_question, :initiator
  has_many :reputation_changes

  # Activities have many notifications which are directed
  # to multiple users. Unlike activities notifications are
  # user-specific in the sense they record information
  # like if a user has actually read the notification, or
  # what is the priority of notification for this user.
  #
  # Note : Currently no prioritization scheme is in place
  # And notifications are ordered just by creation time.
  has_many :notifications, :dependent => :destroy
  has_many :users, :through => :notifications
  belongs_to :subject, :polymorphic => true
  belongs_to :concerned_question, :class_name => "Question"
  belongs_to :initiator, :class_name => "User"
end
