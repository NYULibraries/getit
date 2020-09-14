@wip
Feature: Holding request button for a Copy in Library
  In order to know I can request a Copy in Library
  As a user
  I want to see a request button

  @guest/checked_out
  Scenario: A guest user viewing a "checked out" holding
    Given I am not logged in
    And I am on the GetIt page for a "checked out" holding
    Then I should see a link to login for request options
    And I should not see a request button

  @user/checked_out
  Scenario: A user with request permissions viewing a "checked out" holding
    Given I am logged in
    And I am on the GetIt page for a "checked out" holding
    Then I should see a request button
    And I should not see a link to login for request options

  @guest/offsite
  Scenario: A guest user viewing an "offsite" holding
    Given I am not logged in
    And I am on the GetIt page for an "offsite" holding
    Then I should see a link to login for request options
    And I should not see a request button

  @user/offsite
  Scenario: A user with request permissions viewing a "offsite" holding
    Given I am logged in
    And I am on the GetIt page for an "offsite" holding
    Then I should see a request button
    And I should not see a link to login for request options

  @guest/requested
  Scenario: A guest user viewing a "requested" holding
    Given I am not logged in
    And I am on the GetIt page for a "requested" holding
    Then I should see a link to login for request options
    And I should not see a request button

  @user/requested
  Scenario: A user with request permissions viewing a "requested" holding
    Given I am logged in
    And I am on the GetIt page for a "requested" holding
    Then I should see a request button
    And I should not see a link to login for request options

  @guest/processing
  Scenario: A guest user viewing a "processing" holding
    Given I am not logged in
    And I am on the GetIt page for a "processing" holding
    Then I should see a link to login for request options
    And I should not see a request button

  @user/processing
  Scenario: A user with request permissions viewing a "processing" holding
    Given I am logged in
    And I am on the GetIt page for a "processing" holding
    Then I should see a request button
    And I should not see a link to login for request options

  @guest/on_order
  Scenario: A guest user viewing a "on order" holding
    Given I am not logged in
    And I am on the GetIt page for a "on order" holding
    Then I should see a link to login for request options
    And I should not see a request button

  @user/on_order
  Scenario: A user with request permissions viewing a "on order" holding
    Given I am logged in
    And I am on the GetIt page for a "on order" holding
    Then I should see a request button
    And I should not see a link to login for request options

  @guest/ill
  Scenario: A guest user viewing a "ill" holding
    Given I am not logged in
    And I am on the GetIt page for a "ill" holding
    Then I should see a link to login for request options
    And I should not see a request button

  @user/ill
  Scenario: A user with request permissions viewing a "ill" holding
    Given I am logged in
    And I am on the GetIt page for a "ill" holding
    Then I should see a request button
    And I should not see a link to login for request options

  @guest/available
  Scenario: A guest user viewing an "available" holding
    Given I am not logged in
    And I am on the GetIt page for a "available" holding
    Then I should not see a link to login for request options
    And I should not see a request button

  @user/available
  Scenario: A user with request permissions viewing a "available" holding
    Given I am logged in
    And I am on the GetIt page for a "available" holding
    Then I should see a request button
    And I should not see a link to login for request options
