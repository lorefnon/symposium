class AnswersAuthorizer < ApplicationAuthorizer
  def self.creatable_by? (user)
    user.is_active
  end
end
