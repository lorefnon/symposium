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

class Comment < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = ''
  belongs_to :target, :polymorphic => true
  belongs_to :creator, :class_name => "User"

  has_many :moderators, :through => :target

end
