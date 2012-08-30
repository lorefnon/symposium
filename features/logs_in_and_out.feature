Feature: user authentication

  Scenario: user who is not logged in finds login link in home page
    Given I am not logged in
    And I visit the home page
    Then I should find a link to log in
    And I should not find a link to log out

  Scenario: user visits login page
    Given I am not logged in
    And I visit the home page
    And I click on the "log in" link
    Then I should be directed to the login page

  Scenario: user logs in successfully
    Given I am not logged in
    And I visit the login page
    And there is a user with email "harry_potter@hogwarts.edu" and password "alohomora"
    When I fill in "harry_potter@hogwarts.edu" as email and "alohomora" as password
    Then I should be directed to the home page
    And I should see successful registration message

  Scenario: user attempts to log in with incorrect credentials
    Given I am not logged in
    And I visit the login page
    When I fill some arbitrary credentials
    Then I should be re-directed to the same page
    And I should be prompted to correct the login information

  Scenario: logged in user visits login page
    Given I am logged in
    And I visit the home page
    Then I should not find a login button
    And I should find a logout button

  Scenario: user logs out
    Given I am logged in
    And I visit the home page
    And I click on the logout link
    Then I should be logged out
    And I should be redirected to home page
