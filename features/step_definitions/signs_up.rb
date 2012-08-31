def fill_valid_reg
  fill_in "user_user_name", :with => "lorem_ipsum"
  fill_in "user_email", :with => "lorem@ipsum.com"
  fill_in "user_first_name", :with => "lorem"
  fill_in "user_last_name", :with => "ipsum"
  fill_in "user_password", :with => "password"
  fill_in "user_password_confirmation", :with => "password"
end

Then "I should find a link to registration page" do
  page.should have_link "Register"
end

Then "I should be directed to the registration page" do
  current_path.should match /\/users\/sign_up(.*)/
end

When "I sign up successfully" do
  fill_valid_reg
  click_on "Sign Up"
end

Then "I should be re-directed to home page" do
  current_path.should eq "/"
end

Given /^There exists a user whose "(.*)" is "(.*)"$/ do |field, value|
  User.make! field => value
end

When "I visit user registration page" do
  visit "/users/sign_up.html"
end

When "I fill up the registration form with valid values" do
  fill_valid_reg
end

Then "I should be re-directed to the home page" do
  current_path.should eq "/"
end

Then "I should not find a registration link" do
  page.should_not have_link "Register"
end
