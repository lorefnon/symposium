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
      @que.valid?.should be_true
    end
  end

  describe "#update" do
    it "notifies subscribers about this operation" do
      u = User.make!
      @que.subscribers << u
      @que.title = "some other title"
      @que.save
      activity = @que.activities.where("description = ?", :updated).first
      activity.should_not be_nil
      notif = activity.notifications
        .includes(:user)
        .where("users.id = ?", u.id)
        .first
      notif.should_not be_nil
    end

    it "notifies tag subscribers about this operation" do
      t = Tag.make!
      u = User.make!
      t.subscribers << u
      q = @que
      q.tags << t
      q.title = "some other question"
      q.save
      activity = q.activities.where("description = ?", :updated).first
      activity.should_not be_nil
      notif = activity.notifications
        .includes(:user)
        .where("users.id = ?", u.id)
        .first
      notif.should_not be_nil

    end
  end

  describe "#delete" do
    it "notifies subscribers about this operation" do
      u = User.make!
      @que.subscribers << u
      @que.destroy
      activity = @que.activities.where("description = ?", :removed).first
      activity.should_not be_nil
      notif = activity.notifications
        .includes(:user)
        .where("users.id = ?", u.id)
        .first
      notif.should_not be_nil
    end
  end

  describe "#create" do
    it "notifies tag subscribers about this operation" do
      t = Tag.make!
      u = User.make!
      t.subscribers << u
      q = Question.make
      q.tags << t
      q.save
      activity = q.activities.where("description = ?", :asked).first
      activity.should_not be_nil
      notif = activity.notifications
        .includes(:user)
        .where("users.id = ?", u.id)
        .first
      notif.should_not be_nil
    end
  end

end
