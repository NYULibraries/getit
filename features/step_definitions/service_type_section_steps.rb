Then(/^I should see the "(.*?)" section$/) do |section|
  expect(page).to have_css('.umlaut-section .section_heading', text: section)
end
