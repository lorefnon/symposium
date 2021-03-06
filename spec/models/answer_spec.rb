# == Schema Information
#
# Table name: answers
#
#  id             :integer          not null, primary key
#  body           :text             default(""), not null
#  creator_id     :integer          not null
#  question_id    :integer          not null
#  upvote_count   :integer          default(0)
#  downvote_count :integer          default(0)
#  is_flagged     :boolean          default(FALSE)
#  is_active      :boolean          default(TRUE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Answer do

  before :each do
    @que = Question.make!
    @user = User.make!
    @que.subscribers << @user
    @ans = Answer.make! :question => @que
    @user2 = User.make!
    @ans.subscribers << @user2
  end

  describe "blueprint" do
    it "passes validation rules" do
      @ans.valid?.should be_true
    end
  end

  describe "#create" do
    it "notifies the subscribers of question about creation" do
      activity = Activity.where(:concerned_question_id => @ans.question.id,
                                :subject_id => @ans.id,
                                :description => "answered")
        .first
      activity.should_not be_nil
      notif = activity.notifications
        .includes(:user)
        .where("users.id = ?", @user.id)
        .first
      notif.should_not be_nil
    end
  end
  describe "#update" do
    it "notifies the subscribers of question about update" do
      @ans.body = "some other text"
      @ans.save
      activity = Activity.where(:concerned_question_id => @ans.question.id,
                                :subject_id => @ans.id,
                                :description => "updated an answer for ")
        .first
      activity.should_not be_nil
      notif = activity.notifications
        .includes(:user)
        .where("users.id = ?", @user.id)
        .first
      notif.should_not be_nil
    end
    it "notifies its own subscribers about the update" do
      @ans.body = "changed text"
      @ans.save
      activity = Activity.where(:concerned_question_id => @ans.question.id,
                                :subject_id => @ans.id,
                                :description => "updated an answer for ")
        .first
      activity.should_not be_nil
      notif = activity.notifications
        .includes(:user)
        .where("users.id = ?", @user2.id)
        .first
      notif.should_not be_nil
    end
  end
  describe "#destroy" do
    before :each do
      puts "answer id = #{@ans.id}"
      @ans.destroy
      @activity = Activity.where(:concerned_question_id => @ans.question.id,
                                 :subject_id => @ans.id,
                                 :description => "removed an answer for ")
        .first
    end
    it "notifies its own subscribers about deletion" do
      @activity.should_not be_nil
      notif = @activity.notifications
        .includes(:user)
        .where("users.id = ?", @user.id)
        .first
      notif.should_not be_nil
    end
    it "notifies the subscribers of question about deletion" do
      notif = @activity.notifications
        .includes(:user)
        .where("users.id = ?", @user2.id)
        .first
      notif.should_not be_nil
    end
  end
end
