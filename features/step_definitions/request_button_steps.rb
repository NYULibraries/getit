Given(/^I click the "Request" button$/) do
  within holding_information_row_css do
    click_link 'Request'
  end
end

Then(/^I should see a link to login for request options$/) do
  expect(page).to have_css(request_login_link_css, text: 'Login to Request')
end


Then(/^I should not see a link to login for request options$/) do
  expect(page).not_to have_css(request_login_link_css, text: 'Login to Request')
end

Then(/^I should see a request button$/) do
  expect(page).to have_css(request_button_css, text: 'Request')
end


Then(/^I should not see a request button$/) do
  expect(page).not_to have_css(request_button_css, text: 'Request')
end
