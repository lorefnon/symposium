Then /^I should a list of '(\d+)' most recent questions$/ do |n|
  qlist = Question.order("created_at DESC").limit(n)
  qlist.each do |q|
    page.should have_content q.title
  end
end

Then /^I should find a question search box$/ do
  page.should have_selector "input[name='tags']"
end

Given /^a question "(.*)" has been tagged with "(.*)"$/ do |q_title, tag_name|
  q = Question.make! :title => q_title
  q.tags << Tag.make!(:name => tag_name)
end

When "I visit the questions index page" do
  visit "/questions.html"
end

When /^I search for questions tagged "(.*)"$/ do |tag|
  fill_in "tags", :with => tag
  click_on "Search"
end

Then /^the result set should include "(.*)"$/ do |title|
  page.should have_content title
end
