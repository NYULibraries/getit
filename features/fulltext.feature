Feature: Online Access
  In order to know what Online Access is available
  As a user
  I want to see Online Access

  @new_yorker
  Scenario: Online Access displays for fulltext
    Given I am on the GetIt page for "The New Yorker"
    Then I should see the "Online Access" section
    And I should see "E Journal Full Text" as a link to fulltext
    And I should see "1925 – latest:" as the coverage summary for the online access
    And I should see "NYU access only" as the authentication instructions for the online access
    And I should see "Available from 1925." as the coverage statement for the online access
