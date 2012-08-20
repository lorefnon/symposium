def sign_in email, password
  visit "/users/sign_in.html"
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_on "Sign In"
end

def sign_out
  visit "/users/sign_out.html"
end
