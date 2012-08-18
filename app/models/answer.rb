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

class Answer < ActiveRecord::Base
  include Authority::Abilities
  after_save :post_save
  self.authorizer_name = "AnswersAuthorizer"

  attr_accessible :body
  belongs_to :creator, :class_name => "User"
  belongs_to :question
  has_many :comments

  has_many :moderators, :through => :question
  has_many :activities, :as => :subject

  is_opinable
  is_commentable
  is_subscribable

  default_value_for :downvote_count, 0
  default_value_for :upvote_count, 0
  default_value_for :is_flagged, false
  default_value_for :is_active, true

  def post_save
    desc = if created_at_changed? then "created" else "edited" end

    activity = Activity.create :subject => self,
    :description => desc

    q_subscribers = self.question.subscribers.all
    a_subscribers = self.subscribers.all

    (q_subscribers + a_subscribers).each do |subscriber|
      Notification.create :user => subscriber, :activity => activity
    end

  end
end
