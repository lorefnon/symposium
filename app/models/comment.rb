# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  body        :text
#  creator_id  :integer
#  target_id   :integer
#  target_type :integer
#  is_flagged  :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "notifier"

class Comment < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = ''
  belongs_to :target, :polymorphic => true
  belongs_to :creator, :class_name => "User"

  has_many :moderators, :through => :target

  # given an activity notify to all the subscribers.
  def notify activity

    # people who are subscribed to the tags of the question
    t_subscribers = target.subscribers.all

    (t_subscribers).each do |subscriber|
      Notification.create :user => subscriber, :activity => activity
    end
  end

  has_many :activities, :as => :subject

  after_create :notify_about_creation
  after_update :notify_about_update
  after_destroy :notify_about_destruction

  def concerned_question
    if self.target.instance_of? Question
      self.target
    else self.target.question
    end
  end

  def notify_about_creation
    notify Activity.create :concerned_question => concerned_question,
    :description => "added a comment for ",
    :initiator => self.creator,
    :subject => self.target
  end

  def notify_about_update
    notify Activity.create :concerned_question => concerned_question,
    :description => "updated his comment for ",
    :initiator => self.creator,
    :subject => self.target
  end

  def notify_about_destruction
    notify Activity.create :concerned_question => concerned_question,
    :description => "removed his comment for ",
    :initiator => self.creator,
    :subject => self.target
  end

end
