Given(/^I am logged in$/) do
  ENV['PDS_HANDLE'] = 'PDS_HANDLE'
end

Given(/^I am not logged in$/) do
  ENV['PDS_HANDLE'] = nil
end

