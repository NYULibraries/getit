Then(/^I should( not)? see an embedded option to request this item from E\-ZBorrow$/) do |negator|
  if negator
    expect(page).to_not have_text 'Request a copy from E-ZBorrow'
    # expect(page).to_not have_css('select#pickup_location')
  else
    expect(page).to have_text 'Request a copy from E-ZBorrow'
    # expect(page).to have_css('select#pickup_location')
  end
end
