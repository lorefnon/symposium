class SubscriptionAuthorizer < ApplicationAuthorizer
  def self.default(adjective, user)
    user.is_active
  end
  def deletable_by? (user)
    user.id == resource.subscriber.id or user.role == "admin"
  end
end
