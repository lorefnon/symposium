class QuestionAuthorizer < ApplicationAuthorizer
  def creatable_by? (user)
    true
  end
end
