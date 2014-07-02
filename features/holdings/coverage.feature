Feature: coverage statement for a Copy in Library
  In order to know what coverage a Copy in Library has
  As a user
  I want to see a coverage statement

  @new_yorker
  Scenario: Coverage statement
    Given I am on the GetIt page for "The New Yorker"
    Then I should see "Available in SpecCol: 1925-1965" in a copy's coverage statement
    Then I should see "Note: Some volumes held OffSite -- consult detailed holdings for location." in a copy's coverage statement
    Then I should see "Available in Periodicals: v.81(2005)-" in a copy's coverage statement
    Then I should see "Available in Closed Periodical Stacks: v.1(1925)-v.81(2005)" in a copy's coverage statement

  @vogue
  Scenario: Coverage statement
    Given I am on the GetIt page for the title "Vogue"
    Then I should see "Available in Microform: VOLUMES: 1-180 (YEARS: 1892-1990)" in a copy's coverage statement
    Then I should see "Available in Microform: VOLUMES: 181- (YEARS: 1991-)" in a copy's coverage statement
    Then I should see "Available in Periodicals: v.95 (1940)-" in a copy's coverage statement
    Then I should see "Available in SpecCol Periodicals: v.48 (1916)-49 (1917), 59 (1922)-62 (1923), 70 (1927)-94 (1939)" in a copy's coverage statement
