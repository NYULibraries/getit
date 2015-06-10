Given(/^I am logged in$/) do
  OmniAuth.config.mock_auth[:nyulibraries] = omniauth_hash
  visit '/users/auth/nyulibraries'
end

Given(/^I am not logged in$/) do
  OmniAuth.config.mock_auth[:nyulibraries] = nil
end

Then(/^I should see a login link$/) do
  expect(page).to have_css('.nyu-login i.icons-famfamfam-lock_open')
  expect(page).to have_css('.nyu-login a.login')
end

Then(/^I should see "(.*?)" as the text of the login link$/) do |text|
  login_link = find(:css, '.nyu-login a.login')
  expect(login_link).to have_text text
end

Then(/^I should see a logout link$/) do
  expect(page).to have_css('.nyu-login i.icons-famfamfam-lock')
  expect(page).to have_css('.nyu-login a.logout')
end

Then(/^I should see "(.*?)" as the text of the logout link$/) do |text|
  logout_link = find(:css, '.nyu-login a.logout')
  expect(logout_link).to have_text text
end

Then(/^I should see the login page in the current window$/) do
  pending
  expect(page).to have_text 'Select your affiliation'
end
