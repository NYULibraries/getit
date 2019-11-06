Given(/^I am on the GetIt journal list page$/) do
  visit '/search/journal_list'
end

Given(/^I am on the GetIt search page$/) do
  visit '/search'
end

When(/^I search for the journal title "(.+)"$/) do |search_text|
  within "#primary-search" do
    fill_in "journal_title", with: search_text
    click_on "Search"
  end
end

When(/^I should be redirected to the Citation Linker for the (.+) view$/) do  |view|
  expect(page.driver.current_url).to include "http://bobcatdev.library.nyu.edu/primo-explore"
end

