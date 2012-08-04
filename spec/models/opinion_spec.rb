# == Schema Information
#
# Table name: opinions
#
#  id           :integer          not null, primary key
#  action       :string(255)
#  creator_id   :integer
#  score_change :integer
#  target_id    :integer
#  target_type  :integer
#  to_flag      :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Opinion do
  pending "add some examples to (or delete) #{__FILE__}"
end
