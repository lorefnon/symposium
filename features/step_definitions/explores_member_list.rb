Then "I should see a link to the community page" do
  find_link("Community").should be_visible
end

When "I visit the community page" do
  visit("/community")
end

Then "I should see a listing of 10 most reputed community members" do
  ulist = User.order("reputation DESC").limit(10)
  ulist.each do |u|
    page.should have_content u.title
  end
end

Given /^There exists a user named "(.*)"$/ do |user_name|
  User.make! :user_name => user_name
end

When /^I search for user named "(.*)"$/ do |query|
  fill_in "user_name", :with => query
end

When /^I should be presented with a link to the profile of "(.*)"$/ do |user_name|
  u = User.find_by_user_name user_name
  page.should have_selector "a[href='/members/#{u.id}.html']"
end

Given /^there is no user with name "(.*)"$/ do |user_name|
  u = User.find_by_user_name user_name
  u.destroy unless u.nil?
end
