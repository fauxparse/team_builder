When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end

When(/^I click the "([^"]*)" button$/) do |button|
  click_button(button)
end

When(/^I wait for the save to complete$/) do
  # TODO: this should work :/
  # expect(page).to have_css(".saving")
  # expect(page).not_to have_css(".saving")
  sleep 2
end
