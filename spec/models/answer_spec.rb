# == Schema Information
#
# Table name: answers
#
#  id             :integer          not null, primary key
#  body           :text             default(""), not null
#  creator_id     :integer          not null
#  question_id    :integer          not null
#  upvote_count   :integer          not null
#  downvote_count :integer          not null
#  is_flagged     :boolean          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Answer do

  before :each do
    @ans = Answer.make!
  end

  describe "blueprint" do
    it "passes validation rules" do
      @ans.valid?.should be_true
    end
  end

end
