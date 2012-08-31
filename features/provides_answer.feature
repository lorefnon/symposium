Feature: Answer submission

  Background:
    Given there is a question "What are medicinal properties of Mandrake ?"

  Scenario: Guest user tries to add an answer
    Given I am not logged in
    When I visit the page for the question "What are medicinal properties of Mandrake ?"
    And I click on the "Add an answer" link
    Then I should be redirected to sign in page

  Scenario: Logged in user tries to add an answer
    Given I am logged in
    When I visit the page for the question "What are medicinal properties of Mandrake ?"
    And I click on the "Add an answer" link
    Then I should be presented with a form for providing an answer

  Scenario: Logged in user submits an answer
    Given I am logged in
    When I visit the page for the question "What are medicinal properties of Mandrake ?"
    And I click on the "Add an answer" link
    And I provide "Pain killer and sedative" as the answer body
    And I click on the "Submit Answer" button
    Then I should see the message "Creation successful"
