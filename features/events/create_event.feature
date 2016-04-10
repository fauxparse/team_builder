Feature: Create an event
  @javascript
  Scenario: Everything just works
    Given I am logged in as an admin user
     When I visit the new event page
      And I fill in "Event name" with "A fancy party"
      And I fill in "Start date" with "27 Jul 2016"
      And I fill in "Time" with "8:00 PM"
      And I fill in "Until" with "11:00 PM"
      And I click the "Create event" button
      And I wait for the save to complete
     Then I should be on the newly-created event's page
      And I should see "A fancy party"
      And I should see "Wednesday, 27 July, 2016"
      And I should see "8:00 PM – 11:00 PM"

  @javascript
  Scenario: Error checking
    Given I am logged in as an admin user
     When I visit the new event page
      And I click the "Create event" button
      And I wait for the save to complete
     Then I should be on the new event page
      And I should see "Event name can’t be blank"
      And I should see "URL can’t be blank"
