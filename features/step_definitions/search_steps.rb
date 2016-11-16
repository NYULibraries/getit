Given(/^I am on the GetIt search page$/) do
  visit '/search'
end

When(/^I search for the journal title "(.+)"$/) do |search_text|
  within "#primary-search" do
    fill_in "journal_title", with: search_text
    click_on "Search"
  end
end
