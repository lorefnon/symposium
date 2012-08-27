# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  user_name              :string(255)      not null
#  first_name             :string(255)      not null
#  mid_name               :string(255)
#  last_name              :string(255)      not null
#  address                :text
#  role                   :string(255)
#  city                   :string(255)
#  zip                    :string(255)
#  country                :string(255)
#  gender                 :string(255)
#  reputation             :integer
#  is_active              :boolean
#  signature              :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe User do
  before :each do
    @user = User.make
  end

  describe "blueprint" do
    it "passes validations when created from blueprint" do
      @user.valid?.should be_true
    end
  end

  describe "#user_name" do
    it "must comprise of alphabets, numbers, underscores, hyphens only" do
      @user.user_name = "Harry Potter"
      @user.valid?.should be_false
      @user.user_name = "Harry#Potter"
      @user.valid?.should be_false
      @user.user_name = "harrypotter@hogwarts.com"
      @user.valid?.should be_false
      @user.user_name = "harry"
      @user.valid?.should be_true
    end

    it "must be unique" do
      @user.user_name = "some_user"
      @user.save.should be_true
      u = User.make
      u.user_name = "some_user"
      u.save.should be_false
    end
  end

  describe "#gender" do
    it "automatically normalizes values" do
      @user.gender = "Male"
      @user.gender.should == "m"
      @user.gender = "MALE"
      @user.gender.should == "m"
      @user.gender = "M"
      @user.gender.should == "m"
      @user.gender = "m"
      @user.gender.should == "m"
      @user.gender = "Female"
      @user.gender.should == "f"
      @user.gender = "FEMALE"
      @user.gender.should == "f"
      @user.gender = "female"
      @user.gender.should == "f"
      @user.gender = "f"
      @user.gender.should == "f"
      @user.gender = "F"
      @user.gender.should == "f"
    end
  end

  describe "#reputation" do
    it "must be an integer" do
      @user.reputation = 55.92
      @user.valid?.should be_false
    end
  end

  describe "#signature" do
    it "auto-escapes html content" do
      @user.signature = "<b>Hello </b>World"
      @user.signature.should == "Hello World"
    end
  end

  describe "#email" do
    it "should be a valid email" do
      @user.email = "incomplete@email"
      @user.valid?.should be_false
      @user.email = "complete@email.com"
      @user.valid?.should be_true
    end

    it "should be unique" do
      @user.email = "complete@email.com"
      @user.save.should be_true
      u = User.make
      u.email = "complete@email.com"
      u.save.should be_false
    end
  end
end
