# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  title          :string(255)      not null
#  description    :text             default(""), not null
#  creator_id     :integer          not null
#  upvote_count   :integer          not null
#  downvote_count :integer          not null
#  is_closed      :boolean          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require "opinable"
require "commentable"
require "subscribable"

class Question < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  has_many :answers, :dependent => :destroy

  attr_accessible :title, :description, :upvote_count, :downvote_count

  has_many :answerers,
  :through => :answers,
  :source => :creator

  has_many :tags

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
end
