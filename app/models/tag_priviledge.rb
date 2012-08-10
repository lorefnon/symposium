class TagPriviledge < ActiveRecord::Base
  attr_accessible :priviledge
  belongs_to :user
  belongs_to :tag
end
