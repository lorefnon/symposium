Feature: Browsing of member list

  Scenario: User finds the link to community page in home page
    When I visit the home page
    Then I should see a link to the community page

  Scenario: User visits the community page
    When I visit the community page
    I should see a listing of 10 most reputed community members

  Scenario: user searches for an existing member by name
    Given There exists a user named "draco_malfoy"
    When I visit the community page
    And I search for "draco_malfoy"
    Then I should be presented with a link to his profile

  Scenario: user searches for the name of a non existinng member
    Given there is no user with name "eliot_spencer"
    When I visit the community page
    And I search for "eliot_spencer"
    I should be prompted that no such user exists
