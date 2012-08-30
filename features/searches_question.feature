Feature Tag based question search

  Scenario: user explores question list
    When I visit the home page
    Then I should a list of '10' most recent questions

  Scenario: user finds the question search box
    When I visit the home page
    Then I should find a question search box

  Scenario: user searches for questions based on tags
    Given a question "How many ages does a cat have?" has been tagged with "cat"
    When I search for the tag "cat" from the questions index page
    Then the result set should include "How many ages does a cat have?"
