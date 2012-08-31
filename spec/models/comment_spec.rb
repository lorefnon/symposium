# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  body        :text
#  creator_id  :integer
#  target_id   :integer
#  target_type :integer
#  is_flagged  :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Comment do
  before :each do
    @u1 = User.make!
    @u2 = User.make!
    @que = Question.make! :creator => @u1
    @ans = Answer.make! :question => @que, :creator => @u2
    @que.subscribers << @u1
    @ans.subscribers << @u2
  end
  describe "#create" do
    it "notifies the subscribers of target about creation" do
      cmt = Comment.make! :target => @que
      activity = Activity
        .where(:concerned_question_id => @que.id,
               :subject_id => @que.id,
               :description => "added a comment for ")
        .first
      activity.should_not be_nil
      notif = activity.notifications.includes(:user)
        .where("users.id = ?", @u1.id)
        .first
      notif.should_not be_nil

      cmt = Comment.make! :target => @ans
      activity = Activity
        .where(:concerned_question_id => @ans.question.id,
               :subject_id => @ans.id,
               :description => "added a comment for ")
        .first
      activity.should_not be_nil
      notif = activity.notifications.includes(:user)
        .where("users.id = ?", @u2.id)
        .first
      notif.should_not be_nil
    end
  end
  describe "#update" do
    it "notifies the subscribers of target about update" do
      cmt = Comment.make! :target => @que
      cmt.body = "Something else"
      cmt.save!
      activity = Activity
        .where(:concerned_question_id => @que.id,
               :subject_id => @que.id,
               :description => "updated his comment for ")
        .first
      activity.should_not be_nil
      notif = activity.notifications.includes(:user)
        .where("users.id = ?", @u1.id)
        .first
      notif.should_not be_nil
    end
  end
  describe "#destroy" do
    it "notifies the subscribers of target about deletion" do
      cmt = Comment.make! :target => @que
      cmt.destroy
      activity = Activity
        .where(:concerned_question_id => @que.id,
               :subject_id => @que.id,
               :description => "removed his comment for ")
        .first
      activity.should_not be_nil
      notif = activity.notifications.includes(:user)
        .where("users.id = ?", @u1.id)
        .first
      notif.should_not be_nil
    end
  end
end
