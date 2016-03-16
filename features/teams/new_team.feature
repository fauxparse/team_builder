Feature: create a team
  @javascript
  Scenario: as a new user
    Given I am signed in as an existing user
      And I visit the new team page
     When I fill in "Team name" with "Testing"
      And I click the "Create team" button
      And I wait for the save to complete
     Then A new team should be created with the name "Testing"
      And I should be on the team's page
      And I should be a member of the team
