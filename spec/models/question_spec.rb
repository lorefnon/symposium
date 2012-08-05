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
