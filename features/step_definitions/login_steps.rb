Around('@omniauth_test') do |scenario, block|
  OmniAuth.config.test_mode = true
  block.call
  OmniAuth.config.test_mode = false
end

Given(/^I am logged in$/) do
  OmniAuth.config.mock_auth[:nyulibraries] = omniauth_hash
  visit '/login'
end

Given(/^I am logged in as a non-AFC user$/) do
  step "I am logged in"
end

Given(/^I am logged in as an AFC user$/) do
  OmniAuth.config.mock_auth[:nyulibraries] = afc_omniauth_hash
  visit '/login'
end

Given(/^I am logged in as a New School user with ILL privileges$/) do
  OmniAuth.config.mock_auth[:nyulibraries] = ns_ill_omniauth_hash
  visit '/login'
end

Given(/^I am logged in as a New School user with E-ZBorrow privileges$/) do
  OmniAuth.config.mock_auth[:nyulibraries] = ns_ezborrow_omniauth_hash
  visit login_path
end

Given(/^I am logged in as an NYUSH user$/) do
  OmniAuth.config.mock_auth[:nyulibraries] = nyush_omniauth_hash
  visit '/login'
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

Then(/^I should be logged out$/) do
  expect(page).to have_text 'Almost logged out'
end

Given(/^I click the logout link$/) do
  find('.nyu-login a.logout').click
end
