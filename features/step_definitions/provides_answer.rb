Given /^there is a question "(.*)"$/ do |que_title|
  Question.make! :title => que_title
end

When /^I visit the page for the question "(.*)"$/ do |que_title|
  q = Question.find_by_title que_title
  visit "/questions/#{q.id}"
end

Then /^I should be redirected to sign in page$/ do
  current_path.should eq "/users/sign_in"
end

Then "I should be presented with a form for providing an answer" do
  page.should have_selector "form#new_answer"
end
