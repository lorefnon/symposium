# == Schema Information
#
# Table name: questions
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  description :text             default(""), not null
#  creator_id  :integer          not null
#  is_closed   :boolean          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "opinable"
require "commentable"
require "subscribable"

class Question < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  has_many :answers, :dependent => :destroy

  has_many :answerers,
  :through => :answers,
  :source => :creator

  has_and_belongs_to_many :tags

  is_opinable
  is_commentable
  is_subscribable

  scope :open, where(:is_closed => false)
  scope :closed, where(:is_closed => true)
end
