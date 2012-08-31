Given "I am not logged in" do
  sign_out
end

Given "I am logged in" do
  u = User.make! :email => "lorem_ipsum@gmail.com", :password => "lorem_ipsum"
  sign_in "lorem_ipsum@gmail.com", "lorem_ipsum"
end

Given "I visit the registration page" do
  visit "/users/sign_up.html"
end

When "I visit the home page" do
  visit "/"
end

When "I click the sign up link in the home page" do
  click_link 'Register'
end

Then /^I should(.*)find a link to log in$/ do |b|
  if b == " not "
    page.should_not have_link "Login"
  else
    find_link("Login").should be_visible
  end
end

Then /^I should(.*)find a link to log out$/ do |b|
  if b == " not "
    page.should_not have_link "Log Out"
  else
    find_link("Log Out").should be_visible
  end
end

When /^I click on the "(.*)" link$/ do |link_name|
  click_link link_name
end

Then /^I should be directed to the login page$/ do
  page.should have_selector "form#new_user"
end

When /^I visit the login page$/ do
  visit "/users/sign_in"
end

Given /^there is a user with email "(.*)" and password "(.*)"$/ do |email, pwd|
  User.make! :email => email, :password => pwd
end

When /^I fill in "(.*)" as email and "(.*)" as password$/ do |email, pwd|
  fill_in "user_email", :with => email
  fill_in "user_password", :with => pwd
end

When /^I Submit the form by clicking on "(.*)" button$/ do |btn|
  click_on btn
end

Then /^I should be directed to the home page$/ do
  current_path.should eq "/"
end

Then /^I should see the message "(.*)"$/ do |message|
  page.should have_content message
end

When "I fill some arbitrary credentials" do
  fill_in "user_email", :with => "mandarin_huxxx@gmail.com"
  fill_in "user_password", :with => "xxxxxxxx"
end

Then "I should be re-directed to the login page" do
  current_path.should match /\/users\/sign_in.*/
end

Then /^I should be prompted with "(.*)"$/ do |msg|
  page.should have_content msg
end
