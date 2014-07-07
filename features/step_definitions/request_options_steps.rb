Then(/^I should see a modal indicating that the holding is checked out$/) do
  expect(page).to have_css('#modal .modal-header h3', text: /is checked out/)
end

Then(/^I should see a modal indicating that the holding is available from the offsite storage facility$/) do
  expect(page).to have_css('#modal .modal-header h3', text: /offsite storage facility/)
end

Then(/^I should see a modal indicating that the holding is available$/) do
  expect(page).to have_css('#modal .modal-header h3', text: /is available at/)
end

Then(/^I should see a modal indicating that the holding is requested$/) do
  expect(page).to have_css('#modal .modal-header h3', text: /is requested/)
end

Then(/^I should see a modal indicating that the holding is currently out of circulation$/) do
  expect(page).to have_css('#modal .modal-header h3', text: /is currently out of circulation/)
end

Then(/^I should see a modal indicating that the holding is currently being processed by library staff$/) do
  expect(page).to have_css('#modal .modal-header h3', text: /currently being processed by library staff/)
end

Then(/^I should see a modal indicating that the holding is on order$/) do
  expect(page).to have_css('#modal .modal-header h3', text: /is on order/)
end

Then(/^I should see an option to recall the holding from a fellow library patron$/) do
  expect(page).to have_text 'Recall this item from a fellow library user.'
  expect(page).to have_text 'The item will be available within 2 weeks.'
end

Then(/^I should see an option to request the holding from another library via Interlibrary Loan \(ILL\)$/) do
  expect(page).to have_text 'Request this item from another library via Interlibrary Loan (ILL).'
  expect(page).to have_text 'Most requests arrive within two weeks. Due dates and renewals are determined by the lending library.'
  expect(page).to have_text 'Article/chapter requests are typically delivered electronically in 3-5 days.'
end

Then(/^I should see an option to request the holding to be delivered to the pickup location of my choice$/) do
  expect(page).to have_text 'Request this item to be delivered to the pickup location of your choice.'
end

Then(/^I should see an option to request a scan of a portion of the holding to be delivered to me electronically$/) do
  expect(page).to have_text 'Request that a portion of the item be scanned and delivered electronically.'
end

Then(/^I should see an option to be added to the request queue$/) do
  expect(page).to have_text 'You may also place a request to be added to the queue.'
end

Then(/^I should see an option for this item to be held for me once processed\.$/) do
  expect(page).to have_text 'Request for this item to be held for you once processed.'
end

Then(/^I should not see an option for this item to be held for me once processed\.$/) do
  expect(page).not_to have_text 'Request for this item to be held for you once processed.'
end
