Feature: invite new members to join my team
  @javascript
  Scenario: successful invitation
    Given I am signed in as an admin user
     When I visit the new members page
      And I fill in the email field with a name and email address
      And I click the "Invite new members" button
      And I wait for the save to complete
     Then I should see "1 invitation(s) sent successfully."
      And the new member should receive an invitation by email

  @javascript
  Scenario: bad email address
    Given I am signed in as an admin user
     When I visit the new members page
      And I fill in the email field with a bad email address
      And I click the "Invite new members" button
      And I wait for the save to complete
     Then I should see "1 invitation(s) failed to send."
      And I should see "Email is invalid"
