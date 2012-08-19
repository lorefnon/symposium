When /^I visit the page for the first time$/ do
  visit "/"
end

Then /^I should see a list of "(\d+)" most recent questions.$/ do |num_items|
  page.should have_css('.que-list-item')
end
