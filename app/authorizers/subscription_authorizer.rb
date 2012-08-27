class SubscriptionAuthorizer < ApplicationAuthorizer
  def self.default(adjective, user)
    user.id == resource.id
  end
  def deletable_by? (user)
    user.id == resource.subscriber.id or user.role == "admin"
  end
end
