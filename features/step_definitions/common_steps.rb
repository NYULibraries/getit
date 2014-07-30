Given(/^I click the "(.*?)" link$/) do |link_text|
  click_link link_text
end

Given(/^I am on the GetIt page for "The New Yorker"$/) do
  visit '/resolve?rft.object_id=110975413975944'
end

Given(/^I am on the GetIt page for the title "(.*?)"$/) do |title|
  visit getit_page_for_holdling_title(title)
end
