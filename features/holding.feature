Feature: Copies in Library
  In order to know what Copies are in the Library
  As a user
  I want to see Copies in Library

  @book
  Scenario: Guest user Copies in Library display for a book
    Given I am not logged in
    And I am on the GetIt page for a "book" holding
    Then I should see the "Copies in Library" section
    And I should the link to the call number maps
    And I should see "NYU Bobst Main Collection" as the copy's location
    And I should see "(HN690.I56 I84 2004)" as the copy's call number
    And I should see the "More Info" button for the copy

  @journal
  Scenario: Guest user Copies in Library display for a journal
    Given I am not logged in
    And I am on the GetIt page for a "journal" holding
    Then I should see the "Copies in Library" section
    And I should the link to the call number maps
    And I should see "NYU Bobst Main Collection" as the copy's location
    And I should see "(HB1 .J55 )" as the copy's call number
    And I should see the "More Info" button for the copy
