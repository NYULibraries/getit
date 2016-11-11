Given(/^I am off campus$/) do
  # When not on travis stub an IP that is always off-campus
  unless ENV['TRAVIS']
    ENV['RAILS_TEST_IP_ADDRESS'] = '127.0.0.1'
  else
  # When on travis just visit the login page, always off campus
    visit root_path
  end
end

Given(/^I am at (.+)$/) do |location|
  ip = ip_for_location(location)
  # If a location IP was found then stub it
  if ip.present?
    ENV['RAILS_TEST_IP_ADDRESS'] = ip
  else
  # If no IP was found, visit the institution login page
    visit root_path('umlaut.institution' => institution_for_location(location))
  end
end

Then(/^I should see the NYU New York view$/) do
  expect(html).to have_content "NYU Libraries"
end

Then(/^I should see the NYU Abu Dhabi view$/) do
  expect(html).to have_content "NYU Abu Dhabi Library"
end

Then(/^I should see the NYU Shanghai view$/) do
  expect(html).to have_content "NYU Shanghai Library"
end

Then(/^I should see the NYU Health Science Library view$/) do
  expect(html).to have_content "NYU Health Sciences Library"
end

Then(/^I should see the New School view$/) do
  expect(html).to have_content "New School Libraries"
end

Then(/^I should see the Cooper Union view$/) do
  expect(html).to have_content "Cooper Union Library"
end

Then(/^I should see the NYSID view$/) do
  expect(html).to have_content "New York School of Interior Design Library"
end
