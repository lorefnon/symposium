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

require 'spec_helper'

describe Activity do
  pending "add some examples to (or delete) #{__FILE__}"
end
