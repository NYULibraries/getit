Given(/^I am on the GetIt journal list page$/) do
  visit '/search/journal_list'
end

When(/^I search for the journal title "(.+)"$/) do |search_text|
  within "#primary-search" do
    fill_in "journal_title", with: search_text
    click_on "Search"
  end
end

When(/^I should be redirected to the Citation Linker for the (.+) view$/) do  |view|
  # expect(page.driver.status_code).to eq(302)
  # expect(response).to redirect_to("http://google.com")
# expect(page.driver.status_code).to eq(302)
#       expect(page.driver.browser.last_response['Location']).to match(/\/en\//[^\/]+\/edit$/)
end

