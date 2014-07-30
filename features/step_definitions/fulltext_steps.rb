Then(/^I should see "(.*?)" as a link to fulltext$/) do |link_text|
  expect(page).to have_css(fulltext_css << ' a', text: /#{link_text}/)
end

Then(/^I should see "(.*?)" as the coverage summary for the online access$/) do |coverage_summary|
  expect(page).to have_css(fulltext_css << ' a span.coverage_summary', text: coverage_summary)
end

Then(/^I should see "(.*?)" as the authentication instructions for the online access$/) do |authentication_instructions|
  expect(page).to have_css(fulltext_css << ' div.response_authentication_instructions', text: authentication_instructions)
end

Then(/^I should see "(.*?)" as the coverage statement for the online access$/) do |coverage_statement|
  expect(page).to have_css(fulltext_css << ' div.response_coverage_statement', text: coverage_statement)
end
