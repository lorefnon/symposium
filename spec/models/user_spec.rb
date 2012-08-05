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
  end
end
