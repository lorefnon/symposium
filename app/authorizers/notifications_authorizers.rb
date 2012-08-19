class NotificationsAuthorizer < ApplicationAuthorizer
  def readable_by? (user)
    user.id == resource.user.id or user.role == "admin"
  end
end
