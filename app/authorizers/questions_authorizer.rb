class QuestionsAuthorizer < ApplicationAuthorizer
  def self.creatable_by? (user)
    return true
  end
end
