Given(/^I am on the GetIt page for an? "(.*?)" holding$/) do |state|
  pending if state == 'recalled'
  visit getit_page_for_holdling_state(state)
end

Then(/^I should see a request button$/) do
  expect(page).to have_css holding_css << ' .btn-primary'
end


Then(/^I should not see a request button$/) do
  expect(page).not_to have_css holding_css << ' .btn-primary'
end
