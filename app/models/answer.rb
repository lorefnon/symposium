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
  belongs_to :creator, :class_name => "User"
  belongs_to :question
  has_many :comments

  is_opinable
  is_commentable
  is_subscribable
end
