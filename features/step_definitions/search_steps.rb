Given(/^I am on the GetIt search page$/) do
  visit '/' if poltergeist? # Rack up
  visit '/search'
end
