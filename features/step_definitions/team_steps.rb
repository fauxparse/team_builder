Then(/^I should be on the team's page$/) do
  current_path = URI.parse(current_url).path
  expect(current_path).to eql team_path(@team)
end

Then(/^I should be a member of the team$/) do
  expect(Member.exists?(user_id: User.last.id, team_id: @team)).to be true
end
