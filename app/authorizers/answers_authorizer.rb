class AnswersAuthorizer < ApplicationAuthorizer
  def creatable_by? (user)
    user.reputation > 500
  end
end
