Given(/^I choose "(.*?)" as my pickup location$/) do |pickup_location|
  select(pickup_location, from: 'Select pickup location:')
end

Given(/^I accept "(.*?)" as my pickup location$/) do |pickup_location|
  expect(page).to have_text "Pickup location is #{pickup_location}."
end

Given(/^I choose "(.*?)"$/) do |choice|
  choose(choice)
end

Given(/^I click the "Submit" button$/) do
  within '.modal-footer' do
    click_button 'Submit'
  end
end

Then(/^I should see a confirmation that my request has been processed$/) do
  expect(page).to have_text "Your request has been processed."
end

Then(/^I should see a message that I will be notified when my item is available to pick up at "(.*?)"$/) do |pickup_location|
  pending_resolution_of_poltergeist_timeout
  expect(page).to have_text "You will be notified when this item is available to pick up at #{pickup_location}."
end

Then(/^I should see the ILL page prepopulated with information about my holding$/) do
  pending_proper_test_users
  main = page.driver.browser.window_handles.first
  popup = page.driver.browser.window_handles.last
  page.driver.browser.switch_to.window(popup)
  # expect(page.title).to eq 'BobCat - ILL - Request a Book'
  page.driver.browser.close
  page.driver.browser.switch_to.window(main)
end
