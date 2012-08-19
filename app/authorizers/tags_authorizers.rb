class TagsAuthorizer < ApplicationAuthorizer
  def self.default(adjective, user)
    user.is_active
  end
  def self.creatable_by? (user)
    user.reputation > 2500
  end
end
