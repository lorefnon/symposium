# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text             default(""), not null
#  creator_id  :integer          not null
#  question_id :integer          not null
#  upvotes     :integer          not null
#  downvotes   :integer          not null
#  is_flagged  :boolean          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Answer do
  pending "add some examples to (or delete) #{__FILE__}"
end
