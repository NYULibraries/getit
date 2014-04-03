Feature: request button for a Copy in Library
  In order to know I can request a library holding
  As a user
  I want to see a request button

  @checked_out
  Scenario: A guest user viewing a "checked out" holding
    Given I am on the GetIt page for a "checked out" holding
    Then I should see a request button

  @offsite
  Scenario: A guest user viewing an "offsite" holding
    Given I am on the GetIt page for an "offsite" holding
    Then I should see a request button

  @requested
  Scenario: A guest user viewing a "requested" holding
    Given I am on the GetIt page for a "requested" holding
    Then I should see a request button

  @recalled
  Scenario: A guest user viewing a "recalled" holding
    Given I am on the GetIt page for a "recalled" holding
    Then I should see a request button

  @ill
  Scenario: A guest user viewing a "ill" holding
    Given I am on the GetIt page for a "ill" holding
    Then I should see a request button

  @available
  Scenario: A guest user viewing an "available" holding
    Given I am on the GetIt page for a "available" holding
    Then I should not see a request button
