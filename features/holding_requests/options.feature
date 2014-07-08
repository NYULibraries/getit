Feature: holding request options for a Copy in Library
  In order to select the appropriate choice
  As a user requesting a Copy in Library
  I want to see my options

  @checked_out
  Scenario: A user with request permissions viewing options for a "checked out" holding
    Given I am logged in
    And I am on the GetIt page for a "checked out" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is checked out
    And I should see an option to recall the holding from a fellow library patron
    And I should see an option to request the holding from another library via Interlibrary Loan (ILL)

  @offsite
  Scenario: A user with request permissions viewing options for an "offsite" holding
    Given I am logged in
    And I am on the GetIt page for an "offsite" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is available from the offsite storage facility
    And I should see an option to request the holding to be delivered to the pickup location of my choice
    And I should see an option to request a scan of a portion of the holding to be delivered to me electronically

  @requested
  Scenario: A user with request permissions viewing options for a "requested" holding
    Given I am logged in
    And I am on the GetIt page for a "requested" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is requested
    And I should see an option to be added to the request queue
    And I should see an option to request the holding from another library via Interlibrary Loan (ILL)

  @processing
  Scenario: A user without request permissions viewing options for a "processing" holding
    Given I am logged in
    And I am on the GetIt page for a "processing" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is currently being processed by library staff
    And I should not see an option for this item to be held for me once processed.
    And I should see an option to request the holding from another library via Interlibrary Loan (ILL)

  @on_order
  Scenario: A user with request permissions viewing options for a "on order" holding
    Given I am logged in
    And I am on the GetIt page for a "on order" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is on order
    And I should see an option for this item to be held for me once processed.
    And I should see an option to request the holding from another library via Interlibrary Loan (ILL)

  @ill
  Scenario: A user with request permissions viewing options for a "ill" holding
    Given I am logged in
    And I am on the GetIt page for a "ill" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is currently out of circulation
    And I should see an option to request the holding from another library via Interlibrary Loan (ILL)

  @available
  Scenario: A user with request permissions viewing options for an "available" holding
    Given I am logged in
    And I am on the GetIt page for a "available" holding
    And I click the "Request" button
    Then I should see a modal indicating that the holding is available
    And I should see an option to request the holding to be delivered to the pickup location of my choice
    And I should see an option to request a scan of a portion of the holding to be delivered to me electronically
