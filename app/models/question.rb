# == Schema Information
#
# Table name: questions
#
#  id              :integer          not null, primary key
#  title           :string(255)      not null
#  description     :text             default(""), not null
#  creator_id      :integer          not null
#  upvote_count    :integer          default(0)
#  downvote_count  :integer          default(0)
#  is_closed       :boolean          default(FALSE)
#  is_active       :boolean          default(TRUE)
#  accepted_ans_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require "opinable"
require "commentable"
require "subscribable"
require "notifier"

class Question < ActiveRecord::Base

  attr_accessible :title, :description, :upvote_count, :downvote_count

  include Authority::Abilities
  self.authorizer_name = "QuestionsAuthorizer"

  belongs_to :creator, :class_name => "User"
  has_many :answers, :dependent => :destroy

  has_many :answerers,
  :through => :answers,
  :source => :creator

  has_and_belongs_to_many :tags

  has_many :tag_subscribers,
  :through => :tags,
  :source => :subscribers

  has_many :moderators, :through => :tags

  is_opinable
  is_commentable
  is_subscribable

  scope :open, where(:is_closed => false)
  scope :closed, where(:is_closed => true)

  validates :title, :presence => true
  default_value_for :is_closed, false
  default_value_for :upvote_count, 0
  default_value_for :downvote_count, 0

  self.per_page = 10

  belongs_to :accepted_ans, :class_name => "Answer"
  has_many :activities, :as => :subject, :dependent => :destroy

  # Takes a set of tag names and identifies
  #   existing tags and creates new tags and
  #   associates them with the question instance
  #
  # params:
  #   tags
  #     - string of comma separated tag names or
  #       array of tag names
  def add_tags tags
    aux_errors = []
    tags = tags.split(",") if tags.instance_of? String
    tags = tags.map{|tag| tag.strip }
    tags.each do |tag_name|
      # find a tag if exists
      tag = Tag.where(:name => tag_name).first

      if tag.nil?
        if Tag.creatable_by? current_user
          t = Tag.new :name => tag_name, :creator => current_user
          aux_errors.push "Tag #{tag_name} could not be saved" unless t.save
        else
          aux_errors.push "You don't have permission to create tag #{tag_name}"
        end
      else
        self.tags << tag
      end
    end
    aux_errors
  end

  extend Notifier

  # given an activity notify to all the subscribers.
  def notify activity

    # people who are subscribed directly to the question
    q_subscribers = self.subscribers.all

    # people who are subscribed to the tags of the question
    t_subscribers = self.tag_subscribers.all

    (q_subscribers + t_subscribers).each do |subscriber|
      Notification.create :user => subscriber, :activity => activity
    end
  end

  notify_about :create
  notify_about :update
  notify_about :destroy, :past => :destroyed, :notif_time => :before

  def get_summary
    return {
      :title => self.title[0...100],
      :description => self.description[0...140],
      :creator_name => self.creator.user_name,
      :creator_id => self.creator.id
    }
  end
end
