When(/^I sign up$/) do
  click_link "Sign up"
  fill_in "Name", with: "New user"
  fill_in "Email", with: @member.email
  fill_in "Password", with: "p4$$w0rd"
  fill_in "Password confirmation", with: "p4$$w0rd"
  click_button "Sign up"
end
