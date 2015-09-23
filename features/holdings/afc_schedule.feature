Feature: Schedule link for an AFC item
  In order to make a schedule at AFC for an item in their main collection
  As a user
  I want to see a Schedule link that takes me to the relevant form

  @user/afc
  Scenario: A user with permissions to AFC viewing a videorecording will see a Schedule option
    Given I am logged in as an AFC user
    And I am on the GetIt page for the title "To kill a mockingbird [videorecording]"
    Then I should see a "Schedule" button

  @guest/afc
  Scenario: A logged out user viewing a videorecording will not see a Schedule option
    Given I am not logged in
    And I am on the GetIt page for the title "To kill a mockingbird [videorecording]"
    Then I should not see a "Schedule" button

  @user/checked_out
  Scenario: A user with permissions to AFC viewing an item not in AFC will not see a Schedule option
    Given I am logged in as an AFC user
    And I am on the GetIt page for a "checked out" holding
    Then I should not see a "Schedule" button

  @user/afc
  Scenario: A user with permissions to AFC viewing a videorecording will see a Schedule option
    Given I am logged in as a non-AFC user
    And I am on the GetIt page for the title "To kill a mockingbird [videorecording]"
    Then I should not see a "Schedule" button
