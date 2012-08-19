# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  priority    :integer
#  activity_id :integer
#  is_read     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Notification < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = "NotificationsAuthorizer"
  attr_accessible :priority, :is_read, :user, :activity
  belongs_to :user
  belongs_to :activity
  scope :unread, where(:is_read => false)

  default_value_for :is_read, false
end
