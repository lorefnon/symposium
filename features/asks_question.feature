Feature: Facility for asking question

  Scenario: user who is not logged in, attempts to ask question
    Given I am not logged in
    When I visit the new question form
    Then I should be redirected to login page

  Scenario: user finds ask button in home page
    Given I am logged in
    When I visit the home page
    Then I should be able to find the "Ask A question" button

  Scenario: user asks a question
    Given I am logged in
    When I visit the new question page
    And I provide "What does the The Mirror of Erised‎ actually show?" as the question title
    And I provide "I saw this abandoned mirror in a deserted classrom and can see the reflection of my parents in it. What to make of this?" as the question description
    And I submit the question
    Then I should see the message "Creation successful"

  Scenario: user attempts to submit question without title
    Given I am logged in
    When I visit the new question page
    And I submit the question
    Then I should be prompted with "Creation failed"
