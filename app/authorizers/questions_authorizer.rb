class QuestionsAuthorizer < ApplicationAuthorizer
  def self.deletable_by? (user)
    user.is_active
  end
  def self.updatable_by? (user)
    user.is_active
  end
  def self.creatable_by? (user)
    user.is_active
  end
  def self.readable_by? (user)
    true
  end
end
