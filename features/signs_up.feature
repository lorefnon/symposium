Feature: New user registration
  Scenario: users finds register link in home page
    Given I am not logged in
    When I visit the home page
    Then I should find a link to registration page

  Scenario: uesr clicks register link to goto register page
    Given I am not logged in
    When I visit the home page
    And I click on the registration link in home page
    Then I should be directed to the registration page

  Scenario: user successfully creates an account
    Given I am not logged in
    When I sign up successfully
    Then I should be re-directed to home page
    And I should see successful registration message

  Scenario: user tries to register with an already registered email address
    Given I am not logged in
    When I visit user registration page
    And I provide an already registered email address
    And I attempt to submit the form
    Then I should be re-directed to the same page
    And I should be prompted to change the email

  Scenario: user tries to register with an already registered user name
    Given I am not logged in
    When I visit the registration page
    And I provide an already registered user_name
    And I attempt to submit the form
    Then I should be re-directed to the same page
    And I should be prompted to change the user name

  Scenario: user tries to submit empty form
    Given I am not logged in
    When I visit the registration page
    And I attempt to submit the form
    Then I should bre re-directed to the same page
    And I should be prompted to enter the missing fields

  Scenario: Logged in user visits registration page
    Given I am logged in
    When I visit the registration page
    Then I should be re-directed to the home page

  Scenario: Logged in user visits home page
    Given I am logged in
    When I visit the home page
    Then I should not find a registration link
