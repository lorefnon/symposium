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

class User < ActiveRecord::Base
  include Authority::UserAbilities
  include Authority::Abilities
  self.authorizer_name = 'UserAuthorizer'
  include ActionView::Helpers::SanitizeHelper

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
  :first_name, :last_name, :mid_name, :address, :city, :zip,
  :country, :gender, :reputation, :is_active, :user_name, :first_name,
  :last_name, :mid_name, :address, :city, :zip, :country, :gender, :reputation,
  :is_active, :signature

  attr_protected :role, :reputation

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

  has_many :opted_subscriptions,
  :class_name => "Subscription",
  :foreign_key => :subscriber_id

  has_many :subscribed_items,
  :through => :subscriptions,
  :source => :target

  has_and_belongs_to_many :moderated_tags,
  :class_name => "Tag",
  :join_table => :moderators_tags,
  :foreign_key => :moderator_id

  has_many :questions_under_moderation,
  :class_name => "Question",
  :through => :moderated_tags,
  :source => :questions

  has_many :answers_under_moderation,
  :class_name => "Answer",
  :through => :moderated_questions,
  :source => :answer

  has_many :tag_priviledges

  has_many :priviledged_tags,
  :class_name => "Tag",
  :through => :tag_priviledges,
  :source => :tag

  has_many :initiated_activiites,
  :class_name => "Activity",
  :foreign_key => :initiator_id

  has_many :notifications

  has_many :subscriptions,
  :class_name => "UserSubscription",
  :foreign_key => "target_id"

  has_many :subscribers, :through => :subscriptions

  scope :active, where(:is_active => true)
  scope :admin, where(:role => "admin")
  scope :moderator, where(:role => "moderator")

  validates :user_name, :format => {
    :with => /^[a-zA-Z0-9_-]*$/,
    :message => "User name should comprise only of letters,"+
    " numbers, underscore and hyphen"
  },
  :length => {
    :minimum => 5,
    :maximum => 20
  },
  :presence => true,
  :uniqueness => true

  [:first_name, :last_name].each do |field|
    validates field,
    :length => {
      :minimum => 2,
      :maximum => 20
    },
    :presence => true
  end

  validates :mid_name,
  :format => {
      :with => /^[a-zA-Z ]*$/,
      :message => "middle name can comprise only of alphabets"
    },
  :allow_blank => true

  validates :country, :format => {
    :with => /^[a-zA-Z]*$/,
    :message => "country can comprise only of alphabets"
  },
  :length => {
    :minimum => 5,
    :maximum => 20
  },
  :allow_blank => true

  validates :city,
  :format => {
    :with => /^[a-zA-Z]*$/,
    :message => "city can comprise only of alphabets"
  },
  :length => {
    :minimum => 5,
    :maximum => 20
  },
  :allow_blank => true

  validates :signature,
  :length => {
    :maximum => 140
  },
  :allow_blank => true

  validates :reputation,
  :numericality => {
    :only_integer => true
  },
  :presence => true

  validates :gender,
  :inclusion => {
    :in => %w(m f),
    :message => "gender is invalid"
  },
  :allow_blank => true

  default_value_for :reputation, 1
  default_value_for :is_active, true
  default_value_for :role, :participant

  def gender
    read_attribute(:gender)
  end

  def gender=(gender)
    write_attribute :gender, gender.downcase[0]
  end

  def signature
    read_attribute(:signature)
  end

  def signature=(sig)
    write_attribute(:signature, strip_tags(sig))
  end

  self.per_page = 10

  def as_json(options)
    if options.nil? then options = {} end
    unless options.has_key? :only
      options[:only] = []
    end
    [:id, :user_name, :first_name, :last_name, :reputation].each do |field|
      options[:only] << field
    end
    options[:include] = {:tag_priviledges => {:include => :tag}}
    super(options)
  end

  def update_profile(config)
    flag = true

    if config.has_key? :password and not config[:password].empty?
      if not config.has_key? :old_password or config[:old_password].empty?
        self.errors.add :old_password, "was not provided"
        flag = false
      end
      if flag and not valid_password? config[:old_password]
        self.errors.add :old_password,  "is not correct"
        flag = false
      end
      if flag and config[:password] != config[:password_confirmation]
        self.errors.add :password_confirmation, "does not match"
        flag = false
      end
      if flag
        password = config[:password]
        flag = self.save
      end
      if flag
        flash[:success] = "Password changed successfully"
      else
        flash[:error] = "Password could not be saved"
      end
    end

    [:password, :password_confirmation, :old_password].each do |field|
      config.delete field
    end

    ret = (flag and self.update_attributes config)
  end
end
