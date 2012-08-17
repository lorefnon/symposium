class QuestionsAuthorizer < ApplicationAuthorizer
  def self.default(adjective, user)
    user.is_active
  end
end
