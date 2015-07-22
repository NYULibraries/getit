Given(/^I am on the GetIt page for an? "(.*?)" holding$/) do |state|
  pending if ['recalled', 'on order'].include?(state)
  visit getit_page_for_holdling_state(state)
end

Then(/^I should the link to the call number maps$/) do
  expect(page).to have_css('#holding .umlaut-section.holding .umlaut_section_content', text: /View Maps and Call Number Locations/)
end

Then(/^I should see "(.*?)" as the copy's location$/) do |location|
  expect(page).to have_css(holding_information_row_css << ' div.location', text: /#{location}/)
end

Then(/^I should see "(.*?)" as the copy's call number$/) do |call_number|
  expect(page).to have_css(holding_information_row_css << ' div.call-number', text: call_number)
end

Then(/^I should see "(.*?)" as the copy's availability status$/) do |availability_status|
  expect(page).to have_css(holding_information_row_css << ' div.status', text: availability_status)
end

Then(/^I should see the copy's availability status as green$/) do
  expect(page).to have_css(holding_information_row_css << ' div.status.text-success')
end

Then(/^I should see the "More Info" button for the copy$/) do
  expect(page).to have_css(holding_information_row_css << ' a.more-info', text: 'More Info')
end

Then(/^I should see "(.*?)" in a copy's coverage statement$/) do |coverage_statement|
  expect(page).to have_css(holding_coverage_row_css << ' ul li', text: coverage_statement)
end

Then(/^I should see a "Schedule" button$/) do
  expect(page).to have_css(holding_information_row_css << ' a.afc-schedule-link', text: 'Schedule')
end

Then(/^I should not see a "Schedule" button$/) do
  expect(page).to_not have_css(holding_information_row_css << ' a.afc-schedule-link', text: 'Schedule')
end
