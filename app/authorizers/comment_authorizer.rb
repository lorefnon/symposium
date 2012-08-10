class CommentAuthorizer < ApplicationAuthorizer
  def self.creatable_by? (user)
    user.reputation > 500 or user.role == "admin"
  end
end
