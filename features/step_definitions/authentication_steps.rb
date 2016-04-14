Given(/^I am (?:signed|logged) in as an existing user$/) do
  visit root_path
  step "I sign in"
end

Given(/^I am (?:signed|logged) in as an admin user$/) do
  @user = admin.user
  visit root_path
  step "I sign in"
end

When(/^I sign up$/) do
  click_link "Create an account"
  fill_in "Name", with: "New user"
  fill_in "Email", with: email
  fill_in "Password (8 characters minimum)", with: "p4$$w0rd"
  fill_in "Password confirmation", with: "p4$$w0rd"
  click_button "Sign up"
end

When(/^I (?:sign|log) in$/) do
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Log in"
end

When(/^I visit the home page$/) do
  visit root_path
end
