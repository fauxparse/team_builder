Given(/^I am signed in as an existing user$/) do
  visit root_path
  step "I sign in"
end

When(/^I sign up$/) do
  click_link "Sign up"
  fill_in "Name", with: "New user"
  fill_in "Email", with: email
  fill_in "Password", with: "p4$$w0rd"
  fill_in "Password confirmation", with: "p4$$w0rd"
  click_button "Sign up"
end

When(/^I sign in$/) do
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Log in"
end

When(/^I visit the home page$/) do
  visit root_path
end
