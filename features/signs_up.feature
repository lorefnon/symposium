Feature: New user registration
  Scenario: users finds register link in home page
    Given I am not logged in
    When I visit the home page
    Then I should find a link to registration page

  Scenario: user clicks register link to goto register page
    Given I am not logged in
    When I visit the home page
    And I click on the "Register" link
    Then I should be directed to the registration page

  Scenario: user successfully creates an account
    Given I am not logged in
    When I visit user registration page
    And I sign up successfully
    Then I should be re-directed to home page
    And I should see the message "Welcome! You have signed up successfully."

  Scenario: user tries to register with an already registered email address
    Given I am not logged in
    And There exists a user whose "email" is "lavendar@gmail.com"
    When I visit user registration page
    And I fill up the registration form with valid values
    And I provide "lavendar@gmail.com" as the user email
    And I click on the "Sign Up" button
    Then I should be prompted with "Email has already been taken"

  Scenario: user tries to register with an already registered user name
    Given I am not logged in
    And There exists a user whose "user_name" is "lavendar"
    When I visit user registration page
    And I fill up the registration form with valid values
    And I provide "lavendar" as the user user_name
    And I click on the "Sign Up" button
    Then I should be prompted with "User name has already been taken"

  Scenario: user tries to submit empty form
    Given I am not logged in
    When I visit user registration page
    And I click on the "Sign Up" button
    Then I should be prompted with "Email can't be blank"
    And I should be prompted with "Password can't be blank"
    And I should be prompted with "User name can't be blank"
    And I should be prompted with "First name can't be blank"
    And I should be prompted with "Last name can't be blank"

  Scenario: Logged in user visits registration page
    Given I am logged in
    When I visit the registration page
    Then I should be re-directed to the home page

  Scenario: Logged in user visits home page
    Given I am logged in
    When I visit the home page
    Then I should not find a registration link
