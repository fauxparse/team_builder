Given(/^I receive an email inviting me to join a team$/) do
  @team ||= FactoryGirl.create(:team)
  @member ||= FactoryGirl.create(:newbie, team: @team)
  @admin ||= FactoryGirl.create(:member, :admin, team: @team)

  InviteMember.new(@member, @admin)
    .on(:success) {}
    .on(:failure) { raise "Invitation failed to send" }
    .call

  expect(unread_emails_for(@member.email).size).to eql 1
end

When(/^I accept the invitation$/) do
  expect(page).to have_content("Accept")
  click_link "Accept"
end

Then(/^I should be on the invitation page$/) do
  expect(current_path).to eq invitation_path(Invitation.last)
end
