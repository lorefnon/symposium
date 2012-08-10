# Other authorizers should subclass this one
class ApplicationAuthorizer < Authority::Authorizer

  # Any class method from Authority::Authorizer that isn't overridden
  # will call its authorizer's default method.
  #
  # @param [Symbol] adjective; example: `:creatable`
  # @param [Object] user - whatever represents the current user in your app
  # @return [Boolean]
  def self.default(adjective, user)
    # 'Whitelist' strategy for security: anything not explicitly allowed is
    # considered forbidden.
    user.is_admin
  end
  def self.readable_by? (user)
    true
  end
  def self.creatable_by? (user)
    user.role == "admin"
  end
  def updatable_by? (user)
    (resource.creator == user and resource.is_active) or
      resource.moderators.include? user or
      user.role == "admin"
  end
  def deletable_by? (user)
    (resource.creator == user and resource.is_active) or
      resource.moderators.include? user or
      user.role == "admin"
  end
end
