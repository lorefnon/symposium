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

class Question < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = "QuestionsAuthorizer"

  belongs_to :creator, :class_name => "User"
  has_many :answers, :dependent => :destroy

  attr_accessible :title, :description, :upvote_count, :downvote_count

  has_many :answerers,
  :through => :answers,
  :source => :creator

  has_many :tags
  has_many :tag_subscribers, :through => :tags
  has_many :moderators, :through => :tags
  has_and_belongs_to_many :tags

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
  has_many :activities, :as => :subject

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

  private

  def before_save
    desc = if created_at_changed? then "created" else "edited" end

    activity = Activity.create :initiator => current_user,
    :subject_id => self.id,
    :subject_type => self.class.name,
    :description => desc

    q_subscribers = self.subscribers.all
    t_subscribers = self.tag_subscribers.all

    (q_subscribers + t_subscribers).each do |subscriber|
      Notification.create :user => subscriber, :activity => activity
    end
  end
end
