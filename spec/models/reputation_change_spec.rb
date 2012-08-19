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

require 'spec_helper'

describe ReputationChange do
  pending "add some examples to (or delete) #{__FILE__}"
end
