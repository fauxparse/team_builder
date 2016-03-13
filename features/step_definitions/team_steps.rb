Given(/^I am a member of a team$/) do
  Member.create(user: user, team: team)
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
