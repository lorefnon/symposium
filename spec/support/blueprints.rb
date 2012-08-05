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
  is_closed {false}
end

Answer.blueprint do
  creator { User.make }
  question { Question.make }
  upvote_count {0}
  downvote_count {0}
end
