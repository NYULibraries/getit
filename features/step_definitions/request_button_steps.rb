Given(/^I am on the GetIt page for an? "(.*?)" item$/) do |type|
  pending if type == "recalled"
  visit resolve_url_for_item_type(type)
end

Then(/^I should see a request button$/) do
  wait_until_copies_in_library_render
  expect(page).to have_css '#holding .umlaut-holdings .umlaut-holding .row-fluid .btn-primary'
end


Then(/^I should not see a request button$/) do
  wait_until_copies_in_library_render
  expect(page).not_to have_css item_css << ' .btn-primary'
end
