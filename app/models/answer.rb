# == Schema Information
#
# Table name: answers
#
#  id             :integer          not null, primary key
#  body           :text             default(""), not null
#  creator_id     :integer          not null
#  question_id    :integer          not null
#  upvote_count   :integer          default(0)
#  downvote_count :integer          default(0)
#  is_flagged     :boolean          default(FALSE)
#  is_active      :boolean          default(TRUE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require "opinable"
require "commentable"
require "subscribable"
require "notifier"

class Answer < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = "AnswersAuthorizer"

  attr_accessible :body
  belongs_to :creator, :class_name => "User"
  belongs_to :question
  has_many :comments
  has_many :activities, :as => :subject

  is_opinable
  is_commentable
  is_subscribable

  default_value_for :downvote_count, 0
  default_value_for :upvote_count, 0
  default_value_for :is_flagged, false
  default_value_for :is_active, true

  def moderators
    self.question.moderators
  end

  extend Notifier

  # given an activity notify to all the subscribers.
  def notify activity

    # people who are subscribed directly to the answer
    a_subscribers = subscribers.all

    # people who are subscribed to the question
    q_subscribers = self.question.subscribers.all

    (q_subscribers + a_subscribers).each do |subscriber|
      if activity.subject.creator.id != subscriber.id
        Notification.create :user => subscriber, :activity => activity
      end
    end
  end

  notify_about :create
  notify_about :update
  notify_about :destroy, :past => :destroyed

  def get_summary
    return {
      :body => self.body[0...140],
      :creator_name => self.creator.user_name,
      :question_title => self.question.title[0...140],
      :creator_id => self.creator.id,
      :question_id => self.question.id
    }
  end
end
