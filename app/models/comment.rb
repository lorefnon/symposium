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

  extend Notifier

  notify_about :create
  notify_about :update
  notify_about :destroy, :past => :destroyed

  def get_summary
    return {
      :target_id => self.target_id,
      :target_type => self.target_type,
      :body => self.body[0...140],
      :creator_id => self.creator.id
    }
  end
end
