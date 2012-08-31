When "I visit the new question form" do
  visit "/questions/new"
end

Then "I should be redirected to login page" do
  current_path.should match /\/users\/sign_in.*/
end

Then /^I should be able to find the "(.*)" button$/ do |btn_name|
  page.should have_link btn_name
end

When "I visit the new question page" do
  visit "/questions/new"
end

When /^I provide "(.*)" as the (.*)$/ do |field_value, field|
  fill_in field.split(" ").join("_"), :with => field_value
end

When "I submit the question" do
  click_on "Submit Question"
end
