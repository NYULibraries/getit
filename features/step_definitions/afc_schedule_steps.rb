Then(/^I should see a "Schedule" button$/) do
  expect(page).to have_css(holding_information_row_css << ' a.afc-schedule-link', text: 'Schedule')
end

Then(/^I should not see a "Schedule" button$/) do
  expect(page).to_not have_css(holding_information_row_css << ' a.afc-schedule-link', text: 'Schedule')
end
