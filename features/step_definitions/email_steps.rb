When(/^I open the email$/) do
  open_last_email_for(@member.email)
end

When(/^I click the first link in the email$/) do
  click_first_link_in_email
end
