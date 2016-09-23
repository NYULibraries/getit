Feature: E-ZBorrow web services
  In order to know the availability of an item in E-ZBorrow
  As an authorized user
  I want to see the E-ZBorrow option embedded in the resolve screen

  @guest/unavailable_nyu
  Scenario: A guest user viewing an unavailable item
    Given I am not logged in
    And I am on the GetIt page for an "unavailable at NYU" holding
    Then I should not see an embedded option to request this item from E-ZBorrow

  @user/unavailable_nyu
  Scenario: NYU user viewing an unavailable item
    Given I am logged in
    And I am on the GetIt page for an "unavailable at NYU" holding
    Then I should see an embedded option to request this item from E-ZBorrow

  @user/unavailable_newschool
  Scenario: New School user viewing an unavailable item
    Given I am logged in as a New School user with E-ZBorrow privileges
    And I am on the GetIt page for an "unavailable at New School" holding
    Then I should see an embedded option to request this item from E-ZBorrow
