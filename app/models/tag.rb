# == Schema Information
#
# Table name: tags
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  creator_id  :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Tag < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = "TagsAuthorizer"
  attr_accessible :name, :description, :creator

  has_and_belongs_to_many :questions
  belongs_to :creator, :class_name => "User"

  has_and_belongs_to_many :moderators,
  :class_name => "User",
  :join_table => "moderators_tags",
  :association_foreign_key => "moderator_id"

  has_many :tag_priviledges

  has_many :priviledged_users,
  :through => :tag_priviledges,
  :class_name => "User",
  :source => :tag

  before_save :normalize_values

  is_subscribable

  validates :name, :presence => true
  validates :creator_id, :presence => true

  def as_json(options)
    if options.nil? then options = {} end
    unless options.has_key? :only
      options[:only] = []
    end
    options[:only] << :id << :name
    super(options)
  end

  def normalize_values
    self.name = self.name.downcase
  end
end
