# == Schema Information
#
# Table name: opinions
#
#  id           :integer          not null, primary key
#  action       :string(255)      not null
#  creator_id   :integer          not null
#  score_change :integer          not null
#  target_id    :integer          not null
#  target_type  :integer          not null
#  to_flag      :boolean          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Opinion do
  before :each do
    @op = Opinion.make
  end
end
