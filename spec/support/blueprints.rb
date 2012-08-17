require 'machinist/active_record'

User.blueprint do
  user_name { "user#{sn}" }
  email {"user#{sn}@somesite.com"}
  first_name {"first#{sn.to_i.to_words}"}
  last_name {"last#{sn.to_i.to_words}"}
  password {"user#{sn}_pwd"}
end

Question.blueprint do
  title { "Some creative question #{sn} of earth shattering importance"}
  description { "Lorem ipsum dolor sit amet ..."}
  creator { User.make }
end

Answer.blueprint do
  creator { User.make }
  question { Question.make }
end

Opinion.blueprint do
  action { "upvote" }
  score_change {0}
  to_flag { false}
end

Moderator.blueprint do
  # Attributes here
end

TagPriviledge.blueprint do
  # Attributes here
end

Notification.blueprint do
  # Attributes here
end

Activity.blueprint do
  # Attributes here
end

ReputationChange.blueprint do
  # Attributes here
end
