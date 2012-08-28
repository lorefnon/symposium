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

  has_many :subscriptions,
  :class_name => "AnswerSubscription",
  :foreign_key => "target_id"

  has_many :subscribers, :through => :subscriptions

  default_value_for :downvote_count, 0
  default_value_for :upvote_count, 0
  default_value_for :is_flagged, false
  default_value_for :is_active, true

  def moderators
    self.question.moderators
  end

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

  after_create :notify_about_creation, :subscribe_to_question
  after_update :notify_about_update
  after_destroy :notify_about_destruction

  def notify_about_creation
    notify Activity.create :concerned_question => self.question,
    :initiator => self.creator,
    :description => "answered",
    :subject => self
  end

  def notify_about_update
    notify Activity.create :concerned_question => self.question,
    :description => "updated an answer for",
    :initiator => self.creator,
    :subject => self
  end

  def notify_about_destruction
    notify Activity.create :concerned_question => self.question,
    :description => "removed an answer for",
    :initiator => self.creator,
    :subject => self
  end

  def subscribe_to_question
    question.subscribers << creator
  end
end
