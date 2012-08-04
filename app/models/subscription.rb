# == Schema Information
#
# Table name: subscriptions
#
#  id            :integer          not null, primary key
#  target_id     :integer
#  target_type   :string(255)
#  subscriber_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Subscription < ActiveRecord::Base
  belongs_to :subscriber, :class_name => "User"
  belongs_to :target, :polymorphic => true
end
