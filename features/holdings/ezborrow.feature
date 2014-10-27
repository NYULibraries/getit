Feature: E-ZBorrow link for a Copy in Library
  In order to get a Copy from another library
  As a user
  I want to see an E-ZBorrow link

  @user/checked_out
  Scenario: A user with permissions to request E-ZBorrow items viewing an "checked out" holding
    Given I am logged in
    And I am on the GetIt page for a "checked out" holding
    Then I should not see an E-ZBorrow button

  @user/the_body_as_home
  Scenario: A user with permissions to request E-ZBorrow items viewing an NYU Bobst Reserve collection personal copy
    Given I am logged in
    And I am on the GetIt page for the title "The body as home"
    Then I should see an E-ZBorrow button

  @user/overcoming_trauma_through_yoga
  Scenario: A user with permissions to request E-ZBorrow items viewing an NYU Bobst Reserve collection item
    Given I am logged in
    And I am on the GetIt page for the title "Overcoming trauma through yoga"
    Then I should see an E-ZBorrow button
