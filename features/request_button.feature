Feature: request button for a Copy in Library
  In order to know I can request an item
  As a user
  I want to see a request button

  @checked_out_item
  Scenario: A guest user viewing a "checked out" item
    Given I am on the GetIt page for a "checked out" item
    Then I should see a request button

  @offsite_item
  Scenario: A guest user viewing an "offsite" item
    Given I am on the GetIt page for an "offsite" item
    Then I should see a request button

  @requested_item
  Scenario: A guest user viewing a "requested" item
    Given I am on the GetIt page for a "requested" item
    Then I should see a request button

  @recalled_item
  Scenario: A guest user viewing a "recalled" item
    Given I am on the GetIt page for a "recalled" item
    Then I should see a request button

  @ill_item
  Scenario: A guest user viewing a "ill" item
    Given I am on the GetIt page for a "ill" item
    Then I should see a request button

  @available_item
  Scenario: A guest user viewing an "available" item
    Given I am on the GetIt page for a "available" item
    Then I should not see a request button
