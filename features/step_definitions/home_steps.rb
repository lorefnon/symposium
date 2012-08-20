require File.dirname(__FILE__) + "/../helpers/user_helpers.rb"

Given "I am not logged in" do
  sign_out
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

When "I sign up successfully" do
  @u = User.make
  fill_in "user_email", :with => @u.email
  fill_in "user_user_name", :with => @u.user_name
  fill_in "user_first_name", :with => @u.first_name
  fill_in "user_last_name", :with => @u.last_name
  fill_in "user_mid_name", :with => @u.mid_name
  fill_in "user_password", :with => "lorem_ipsum"
  fill_in "user_password_confirmation", :with => "lorem_ipsum"
  click_on "Sign Up"
end

Then "I should see a list of '$num_items' most recent questions." do |num_items|
  page.should have_css('.que-list')
  qlist = Question.order("created_at DESC").limit(num_items)
  qlist.each do |q|
    page.should have_content(q.title)
  end
end

Then "I should see a link to registration page" do
  page.should have_css("a[href='/users/sign_up.html']")
end

Then "I should be directed to the registration page" do
  current_path.should eql "/users/sign_up.html"
end

Then "I should be re-directed to home page" do
  current_path.should eql "/"
end

Then "I should see successful registration message" do
  page.should have_content "Welcome! You have signed up successfully."
end
