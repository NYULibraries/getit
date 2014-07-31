Feature: Log in to get holding request options for a Copy in Library
  In order to see my holding request options
  As a user
  I want to be able to log in

  @guest/checked_out
  Scenario: A guest user logging in for a "checked out" holding
    Given I am not logged in
    And I am on the GetIt page for a "checked out" holding
    And I click the "Login for Request Options" link
    Then I should see the login page in the current window
