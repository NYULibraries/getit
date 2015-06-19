Feature: Log in/out links
  In order to easily log in and log out
  As a user
  I want to see the appropriate link

  Scenario: A guest user should see a login link
    Given I am not logged in
    And I am on the GetIt search page
    Then I should see a login link
    And I should see "Login" as the text of the login link

  Scenario: A logged in user on the search page should see a logout link
    Given I am logged in
    And I am on the GetIt search page
    Then I should see a logout link
    And I should see "Log-out Dev" as the text of the logout link

  @user/available
  Scenario: A logged in user on the resolve page should see a logout link
    Given I am logged in
    And I am on the GetIt page for a "available" holding
    Then I should see a logout link
    And I should see "Log-out Dev" as the text of the logout link

  @omniauth_test
  Scenario: A logged in user clicks logout
    Given I am logged in
    And I am on the GetIt search page
    When I click the logout link
    Then I should be logged out
