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

# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text             default(""), not null
#  creator_id  :integer          not null
#  question_id :integer          not null
#  upvotes     :integer          not null
#  downvotes   :integer          not null
#  is_flagged  :boolean          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "opinable"
require "commentable"
require "subscribable"

class Answer < ActiveRecord::Base
  include Authority::Abilities
  attr_accessible :body
  belongs_to :creator, :class_name => "User"
  belongs_to :question
  has_many :comments
  has_many :moderators, :through => :question

  is_opinable
  is_commentable
  is_subscribable

  default_value_for :downvote_count, 0
  default_value_for :upvote_count, 0
  default_value_for :is_flagged, false

end
