@institutions_views
Feature: Institution views by IP location
  In order to keep consistency of visual identity
  As a user
  I want to immediately recognize which institution I am in

  Scenario: Viewing the journal list page from off campus
    Given I am off campus
    And I am on the GetIt journal list page
    Then I should see the NYU New York view

  Scenario: Viewing the resolve page from off campus
    Given I am off campus
    And I am on the GetIt page for "The New Yorker"
    Then I should see the NYU New York view

  Scenario: Viewing the journal list page from NYU New York
    Given I am at NYU New York
    And I am on the GetIt journal list page
    Then I should see the NYU New York view
  
  Scenario: Viewing the search page from NYU New York
    Given I am at NYU New York
    And I am on the GetIt search page
    Then I should be redirected to the Citation Linker for the NYU New York view

  Scenario: Viewing the resolve page from NYU New York
    Given I am at NYU New York
    And I am on the GetIt page for "The New Yorker"
    Then I should see the NYU New York view

  Scenario: Viewing the journal list page from NYU Abu Dhabi
    Given I am at NYU Abu Dhabi
    And I am on the GetIt journal list page
    Then I should see the NYU Abu Dhabi view

  Scenario: Viewing the resolve page from NYU Abu Dhabi
    Given I am at NYU Abu Dhabi
    And I am on the GetIt page for "The New Yorker"
    Then I should see the NYU Abu Dhabi view

  Scenario: Viewing the journal list page from NYU Shanghai
    Given I am at NYU Shanghai
    And I am on the GetIt journal list page
    Then I should see the NYU Shanghai view

  Scenario: Viewing the resolve page from NYU Shanghai
    Given I am at NYU Shanghai
    And I am on the GetIt page for "The New Yorker"
    Then I should see the NYU Shanghai view

  Scenario: Viewing the journal list page from The New School
    Given I am at the New School
    And I am on the GetIt journal list page
    Then I should see the New School view

  Scenario: Viewing the resolve page from The New School
    Given I am at the New School
    And I am on the GetIt page for "The New Yorker"
    Then I should see the New School view

  Scenario: Viewing the journal list page from Cooper Union
    Given I am at Cooper Union
    And I am on the GetIt journal list page
    Then I should see the Cooper Union view

  Scenario: Viewing the resolve page from Cooper Union
    Given I am at Cooper Union
    And I am on the GetIt page for "The New Yorker"
    Then I should see the Cooper Union view
