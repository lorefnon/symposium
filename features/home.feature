Feature: Home Page

  Scenario: user finds most recent questions in home page
    When I visit the home page
    Then I should see a list of '10' most recent questions.

  Scenario: user finds register link in home page
    Given I am not logged in
    When I visit the home page
    Then I should see a link to registration page

  Scenario: user clicks register link to goto register page
    Given I am not logged in
    When I visit the home page
    And I click the sign up link in the home page
    Then I should be directed to the registration page

  Scenario: user successfully creates an account
    Given I visit the registration page
    When I sign up successfully
    Then I should be re-directed to home page
    And I should see successful registration message

  Scenario: user finds login link in home page
    Given I am not logged in
    When I visit the home page
    Then I should see a link to login page

  Scenario: user uses the login link to goto login page
    Given I am not logged in
    When I click the login link in home page
    Then I should be directed to login page

  Scenario: user logs in successfully
    Given I am not logged in
    When I log in from the login page
    Then I should be re-directed to the home page
    And I should see successful login message
