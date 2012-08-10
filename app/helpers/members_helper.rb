require 'digest/md5'

module MembersHelper

  def grav_img member, size = 30
    hash = Digest::MD5.hexdigest member.email
    "http://www.gravatar.com/avatar/#{hash}.jpg?s=#{size}"
  end

  def creator_box item, create_action
    locals = {
      :item => item,
      :creator =>  item.creator,
      :create_action => create_action,
      :img_url => grav_img(item.creator)
    }
    render :partial => "members/creator_box", :locals => locals
  end
end
