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

require 'spec_helper'

describe TagPriviledge do
  pending "add some examples to (or delete) #{__FILE__}"
end
