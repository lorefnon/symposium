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

require 'spec_helper'

describe Subscription do
  pending "add some examples to (or delete) #{__FILE__}"
end
