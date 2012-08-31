class TagsAuthorizer < ApplicationAuthorizer
  def self.default(adjective, user)
    user.is_active
  end
  def self.creatable_by? user
    true
    #user.reputation > 10
  end
  def modifiable_by? user
    resource.creator.id == user.id or
      ( user.role == "moderator" and
        resource.moderators.exists? :id => user.id ) or
      ( user.role == "admin" )
  end
  def editable_by? user
    modifiable_by? user
  end
  def updatable_by? user
    modifiable_by? user
  end
end
