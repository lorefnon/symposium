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
      activity = cmt.activities.where("description = ?", :created).first
      activity.should_not be_nil
      notif = activity.notifications.includes(:user)
        .where("users.id = ?", @u1.id)
        .first
      notif.should_not be_nil

      cmt = Comment.make! :target => @ans
      activity = cmt.activities.where("description = ?", :created).first
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
      activity = cmt.activities.where("description = ?", :updated).first
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
      activity = cmt.activities.where("description = ?", :destroyed).first
      activity.should_not be_nil
      notif = activity.notifications.includes(:user)
        .where("users.id = ?", @u1.id)
        .first
      notif.should_not be_nil
    end
  end
end
