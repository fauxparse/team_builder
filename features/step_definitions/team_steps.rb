Given(/^I am a member of a team$/) do
  Member.create(user: user, team: team)
end

Given(/^I visit the new team page$/) do
  visit new_team_path
end

Then(/^A new team should be created with the name "([^"]+)"$/) do |name|
  @team = Team.find_by(name: name)
  expect(@team).to be_present
end

Then(/^I should be on the team's page$/) do
  expect(current_path).to eql team_path(team)
end

Then(/^I should be a member of the team$/) do
  expect(Member.exists?(user_id: User.last, team_id: team)).to be true
end

Then(/^I should be on the new team page$/) do
  expect(current_path).to eql new_team_path
end

Then(/^no new team should be created$/) do
  expect(Team.count).to eq 0
end
