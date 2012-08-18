# == Schema Information
#
# Table name: activities
#
#  id           :integer          not null, primary key
#  subject_id   :integer
#  subject_type :integer
#  initiator_id :integer
#  description  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Activity < ActiveRecord::Base
  attr_accessible :subject_type, :description, :subject
  has_many :reputation_changes
  has_many :notifications
  has_many :users, :through => :notifications
  belongs_to :subject, :polymorphic => true

  has_one :initiator,
  :through => :subject,
  :class_name => "User",
  :foreign_key => "creator_id"

  def initiator
    return @initiator unless @initiator.nil?
    @initiator = subject.creator
  end
end
