Feature: availability status of a Copy in Library
  In order to know the availability of a Copy in Library
  As a user
  I want to see the availability status

  @journal
  Scenario: A guest user viewing a "journal" holding
    Given I am not logged in
    And I am on the GetIt page for a "journal" holding
    Then I should see "Check Availability" as the copy's availability status

  @checked_out
  Scenario: A guest user viewing a "checked out" holding
    Given I am not logged in
    And I am on the GetIt page for a "checked out" holding
    Then I should see "Due: 10/11/14" as the copy's availability status

  @offsite
  Scenario: A guest user viewing an "offsite" holding
    Given I am not logged in
    And I am on the GetIt page for an "offsite" holding
    Then I should see "Offsite Available" as the copy's availability status
    And I should see the copy's availability status as green

  @requested
  Scenario: A guest user viewing a "requested" holding
    Given I am not logged in
    And I am on the GetIt page for a "requested" holding
    Then I should see "On Hold" as the copy's availability status

  @recalled
  Scenario: A guest user viewing a "recalled" holding
    Given I am not logged in
    And I am on the GetIt page for a "recalled" holding
    Then I should see "Due:" as the copy's availability status

  @ill
  Scenario: A guest user viewing a "ill" holding
    Given I am not logged in
    And I am on the GetIt page for a "ill" holding
    Then I should see "Request ILL" as the copy's availability status

  @available
  Scenario: A guest user viewing an "available" holding
    Given I am not logged in
    And I am on the GetIt page for a "available" holding
    Then I should see "Available" as the copy's availability status
    And I should see the copy's availability status as green
