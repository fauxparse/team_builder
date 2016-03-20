Given(/^I receive an email inviting me to join a team$/) do
  InviteMember.new(new_member, admin)
    .on(:success) {}
    .on(:failure) { raise "Invitation failed to send" }
    .call

  expect(unread_emails_for(new_member.email).size).to eql 1
end

When(/^I accept the invitation$/) do
  expect(page).to have_content("Accept")
  click_link "Accept"
end

When(/^I visit the new members page$/) do
  visit new_team_member_path(team)
end

When(/^I fill in the email field with a name and email address$/) do
  fill_in "Names and email addresses", with: %Q{"New User" <new@example.com>}
end

When(/^I fill in the email field with a bad email address$/) do
  fill_in "Names and email addresses", with: "BLOOP"
end

Then(/^I should be on the invitation page$/) do
  expect(current_path).to eq invitation_path(Invitation.last)
end

Then(/^the new member should receive an invitation by email$/) do
  expect(unread_emails_for("new@example.com").size).to eql 1
end
