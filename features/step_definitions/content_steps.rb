Then(/^I should see "([^"]*)"$/) do |text|
  expect(page).to have_content(text)
end

When(/^I take a screenshot$/) do
  save_and_open_screenshot
end
