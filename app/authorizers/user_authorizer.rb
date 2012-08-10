class UserAuthorizer < ApplicationAuthorizer
  def self.creatable_by? (user)
    true
  end
  def updatable_by? (user)
    return user == resource or user.role == "admin"
  end
  def deletable_by? (user)
    return user == resource or user.role == "admin"
  end
end
