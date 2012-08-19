# == Schema Information
#
# Table name: reputation_changes
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  change      :integer
#  activity_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ReputationChange < ActiveRecord::Base
  attr_accessible :change
  belongs_to :user
  belongs_to :activity
end
