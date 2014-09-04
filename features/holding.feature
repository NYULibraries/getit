Feature: Copies in Library
  In order to know what Copies are in the Library
  As a user
  I want to see Copies in Library

  @guest/book
  Scenario: Guest user Copies in Library display for a book
    Given I am not logged in
    And I am on the GetIt page for a "book" holding
    Then I should see the "Copies in Library" section
    And I should the link to the call number maps
    And I should see "NYU Bobst Main Collection" as the copy's location
    And I should see "(HN690.I56 I84 2004)" as the copy's call number
    And I should see the "More Info" button for the copy

  @guest/journal
  Scenario: Guest user Copies in Library display for a journal
    Given I am not logged in
    And I am on the GetIt page for a "journal" holding
    Then I should see the "Copies in Library" section
    And I should the link to the call number maps
    And I should see "NYU Bobst Main Collection" as the copy's location
    And I should see "(HB1 .J55 )" as the copy's call number
    And I should see the "More Info" button for the copy

  @guest/not_by_reason_alone
  Scenario: Guest user Copies in Library display for the book "Not by reason alone"
    Given I am not logged in
    And I am on the GetIt page for the title "Not by Reason Alone"
    Then I should see the "Copies in Library" section
    And I should the link to the call number maps
    And I should see "New School Fogelman Library" as the copy's location
    And I should see "(JA81 .M54 1993)" as the copy's call number
    And I should see the "More Info" button for the copy

  @guest/the_body_as_home
  Scenario: Guest user Copies in Library display for course reserves
    Given I am not logged in
    And I am on the GetIt page for the title "The body as home"
    Then I should see the "Copies in Library" section
    And I should the link to the call number maps
    And I should see "NYU Bobst Reserve Collection" as the copy's location
    And I should see "(YSL1211.A02)" as the copy's call number
    And I should see the "More Info" button for the copy

  @user/the_body_as_home
  Scenario: A user viewing Copies in Library for course reserves
    Given I am logged in
    And I am on the GetIt page for the title "The body as home"
    Then I should see the "Copies in Library" section
    And I should the link to the call number maps
    And I should see "NYU Bobst Reserve Collection" as the copy's location
    And I should see "(YSL1211.A02)" as the copy's call number
    And I should see the "More Info" button for the copy
