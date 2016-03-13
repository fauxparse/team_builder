Feature: accept an invitation
  Scenario: as a new user
    Given I am a new user
      And I receive an email inviting me to join a team
     When I open the email
      And I click the first link in the email
      And I sign up
     Then I should be on the invitation page
     When I accept the invitation
     Then I should be on the team's page
      And I should be a member of the team
