# == Schema Information
#
# Table name: tag_priviledges
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  tag_id     :integer
#  priviledge :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TagPriviledge < ActiveRecord::Base
  attr_accessible :priviledge
  belongs_to :user
  belongs_to :tag
end
