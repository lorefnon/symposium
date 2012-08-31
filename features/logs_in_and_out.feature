Feature: user authentication

  Scenario: user who is not logged in finds login link in home page
    Given I am not logged in
    When I visit the home page
    Then I should find a link to log in
    And I should not find a link to log out

  Scenario: user visits login page
    Given I am not logged in
    When I visit the home page
    And I click on the "Login" link
    Then I should be directed to the login page

  Scenario: user logs in successfully
    Given I am not logged in
    And there is a user with email "harry_potter@hogwarts.edu" and password "alohomora"
    When I visit the login page
    And I fill in "harry_potter@hogwarts.edu" as email and "alohomora" as password
    And I Submit the form by clicking on "Sign In" button
    Then I should be directed to the home page
    And I should see the message "Signed in successfully."

  Scenario: user attempts to log in with incorrect credentials
    Given I am not logged in
    And I visit the login page
    When I fill some arbitrary credentials
    And I Submit the form by clicking on "Sign In" button
    Then I should be re-directed to the login page
    And I should be prompted with "Invalid email or password."

  Scenario: logged in user visits login page
    Given I am logged in
    And I visit the home page
    Then I should not find a link to log in
    And I should find a link to log out

  Scenario: user logs out
    Given I am logged in
    And I visit the home page
    And I click on the "Log Out" link
    Then I should see the message "Signed out successfully."
