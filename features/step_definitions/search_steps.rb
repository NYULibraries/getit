Given(/^I am on the GetIt search page$/) do
  # When using poltergeist visiting a relative url
  # doesn't seem to rack up so manually do it
  visit '/' if poltergeist? # Rack up
  visit '/search'
end
