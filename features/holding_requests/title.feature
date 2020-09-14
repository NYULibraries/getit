@wip
Feature: Holding request modal window title for a Copy in Library
  In order to understand the context of my request
  As a user requesting a Copy in Library
  I want to see an appropriate title on the holding request modal window

  @user/checked_out
  Scenario: A user with request permissions viewing options for a "checked out" holding
    Given I am logged in
    And I am on the GetIt page for a "checked out" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is checked out

  @user/offsite
  Scenario: A user with request permissions viewing options for an "offsite" holding
    Given I am logged in
    And I am on the GetIt page for an "offsite" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is available from the offsite storage facility

  @user/requested
  Scenario: A user with request permissions viewing options for a "requested" holding
    Given I am logged in
    And I am on the GetIt page for a "requested" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is requested

  @user/processing
  Scenario: A user without request permissions viewing options for a "processing" holding
    Given I am logged in
    And I am on the GetIt page for a "processing" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is currently being processed by library staff

  @user/on_order
  Scenario: A user with request permissions viewing options for a "on order" holding
    Given I am logged in
    And I am on the GetIt page for a "on order" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is on order

  @user/ill
  Scenario: A user with request permissions viewing options for a "ill" holding
    Given I am logged in
    And I am on the GetIt page for a "ill" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is currently out of circulation

  @user/available
  Scenario: A user with request permissions viewing options for an "available" holding
    Given I am logged in
    And I am on the GetIt page for a "available" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is available
