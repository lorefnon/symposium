Feature: Facility for asking question

  Scenario: user who is not logged in, attempts to ask question
    Given I am not logged in
    When I visit the new question form
    Then I should be redirected to login page

  Scenario: user finds ask button in home page
    Given I am logged in
    When I visit the home page
    Then I should be able to find the "ask" button

  Scenario: user asks a question
    Given I am logged in
    When I visit the new question page
    And I provide "What does the The Mirror of Erised‎ actually show?" as the question
    And I provide "I saw this abandoned mirror in a deserted classrom and can see the reflection of my parents in it. What to make of this?"
    And submit the question
    Then I should be prompted about successful submission of the question

  Scenario: user attempts to submit question without title
    Given I am logged in
    When I visit the new question page
    And submit the question
    Then I should be prompted to provide a valid question title
