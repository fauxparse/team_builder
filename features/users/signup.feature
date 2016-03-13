Feature: signup as a new user
  Scenario: first-time signup
    Given I am a new user
     When I visit the home page
      And I sign up
     Then I should be on the new team page

  Scenario: first-time sign in
    Given I am an existing user
     When I visit the home page
      And I sign in
     Then I should be on the new team page

  Scenario: sign in with an existing team
    Given I am an existing user
      And I am a member of a team
     When I visit the home page
      And I sign in
     Then I should be on the team's page
