# == Schema Information
#
# Table name: questions
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  description :text             default(""), not null
#  creator_id  :integer          not null
#  is_closed   :boolean          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Question do
  pending "add some examples to (or delete) #{__FILE__}"
end
