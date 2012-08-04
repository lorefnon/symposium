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
  has_and_belongs_to_many :questions
  belongs_to :creator, :class_name => "User"

  is_subscribable
end
