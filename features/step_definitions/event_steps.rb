When(/^I visit the new event page$/) do
  visit new_team_event_path(team)
end

Then(/^I should be on the newly-created event's page$/) do
  expect(current_path)
    .to eq "/teams/#{team.to_param}/events/a-fancy-party/2016/07/27"
end

Then(/^I should be on the new event page$/) do
  expect(current_path).to eq new_team_event_path(team)
end
