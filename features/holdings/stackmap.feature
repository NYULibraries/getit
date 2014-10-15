Feature: "Map" button for a Copy in Library
  In order to find a Copy in the Library
  As a user
  I want to see a "Map" button

  @guest/gothic_architecture
  Scenario: A guest user viewing an "available" New School University Center Main Collection holding
    Given I am not logged in
    And I am on the GetIt page for the title "Gothic architecture"
    Then I should see a blue "Map" button

  @user/gothic_architecture
  Scenario: A user viewing an "available" New School University Center Main Collection holding
    Given I am logged in
    And I am on the GetIt page for the title "Gothic architecture"
    Then I should see a blue "Map" button
