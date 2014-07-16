Given(/^I am on the GetIt search page$/) do
  if Capybara.current_driver == :poltergeist
    pending 'resolution of timeout issue in poltergeist'
  end
  visit '/search'
end
