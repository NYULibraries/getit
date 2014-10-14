Then(/^I should not see an E\-ZBorrow button$/) do
  expect(page).not_to have_css(ezborrow_button_css, text: 'E-ZBorrow')
end

Then(/^I should see an E\-ZBorrow button$/) do
  expect(page).to have_css(ezborrow_button_css, text: 'E-ZBorrow')
end
