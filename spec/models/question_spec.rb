# == Schema Information
#
# Table name: questions
#
#  id              :integer          not null, primary key
#  title           :string(255)      not null
#  description     :text             default(""), not null
#  creator_id      :integer          not null
#  upvote_count    :integer          default(0)
#  downvote_count  :integer          default(0)
#  is_closed       :boolean          default(FALSE)
#  is_active       :boolean          default(TRUE)
#  accepted_ans_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Question do
  before :each do
    @que = Question.make!
  end

  describe "blueprint" do
    it "passes all validations" do
      print @que.to_json
      @que.valid?.should be_true
      print @que.creator.to_json
    end
  end

end
