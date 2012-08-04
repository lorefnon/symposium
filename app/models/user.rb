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

require "subscribable"
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
  :first_name, :last_name, :mid_name, :address, :city, :zip,
  :country, :gender, :reputation, :is_active


  has_many :tags_created,
  :class_name => "Tag",
  :foreign_key => "creator_id"

  has_many :questions_asked,
  :class_name => "Question",
  :foreign_key => "creator_id"

  has_many :comments_received,
  :through => :questions_asked,
  :source => :comments

  has_many :answers_provided,
  :class_name => "Answer",
  :foreign_key => "creator_id"

  has_many :questions_answered,
  :through => :answers_provided,
  :source => :question

  has_many :comments_contributed,
  :class_name => "Comment",
  :foreign_key => "creator_id"

  has_many :upvotes_contributed,
  :class_name => "Opinion",
  :foreign_key => "creator_id",
  :conditions => {:target_type => "upvote"}

  has_many :downvotes_contributed,
  :class_name => "Opinion",
  :foreign_key => "creator_id",
  :conditions => {:target_type => "downvote"}

  has_many :opinions_contributed,
  :class_name => "Opinion",
  :foreign_key => "creator_id"

  has_many :subscriptions, :foreign_key => :subscriber_id

  has_many :subscribed_items,
  :through => :subscriptions,
  :source => :target

  ["question", "answer", "comment", "user"].each do |item|
    has_many ("subscribed_#{item}s").to_sym,
    :through => :subscriptions,
    :source => :target,
    :conditions => {:target_type => item.capitalize}
  end

  is_subscribable()

  scope :active, where(:is_active => true)
end
