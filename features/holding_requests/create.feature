@wip
Feature: Place a hold on a Copy in Library
  In order to place a hold on a Copy in Library
  As a user requesting a Copy in Library
  I want to successfully place a hold

  @user/checked_out
  Scenario: A user with request permissions places a hold on a "checked out" holding
    Given I am logged in
    And I am on the GetIt page for a "checked out" holding
    And I click the "Request" button
    And I choose "NYU Bobst" as my pickup location
    And I click the "Submit" button in the modal footer
    Then I should see a confirmation that my request has been processed
    And I should see a message that I will be notified when my item is available to pick up at "NYU Bobst"

  @user/offsite
  Scenario: A user with request permissions places a hold on an "offsite" holding
    Given I am logged in
    And I am on the GetIt page for an "offsite" holding
    And I click the "Request" button
    And I choose "Request this item to be delivered to the pickup location of your choice."
    And I accept "New School Fogelman Library" as my pickup location
    And I click the "Submit" button in the modal footer
    Then I should see a confirmation that my request has been processed
    And I should see a message that I will be notified when my item is available to pick up at "New School Fogelman Library"

  @user/ill
  Scenario: A user with request permissions places a hold on an "ILL" holding
    Given I am logged in
    And I am on the GetIt page for an "ill" holding
    And I click the "Request" button
    And I click the "Request this item from another library via Interlibrary Loan (ILL)" link
    Then I should see the ILL page prepopulated with information about my holding
