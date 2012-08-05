require 'machinist/active_record'

User.blueprint do
  user_name { "user#{sn}" }
  email {"user#{sn}@somesite.com"}
  first_name {"first#{sn.to_i.to_words}"}
  last_name {"last#{sn.to_i.to_words}"}
  password {"user#{sn}_pwd"}
end
