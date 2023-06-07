require 'devise'
require 'devise/test/integration_helpers'

Given("I am a logged in user and i'm in the  root page") do
  # Implement the logic to simulate a registered seller
  # Simulate a logged-in user
  visit new_user_session_path
  user = User.create(email: 'test.user@example.com', password: 'password', nome: 'Test', cognome: 'Cognome', città: 'Milano')
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
  expect(page).to have_content('Signed in successfully.') # Expectation for success message
  expect(page).to have_current_path(root_path)
  click_link('my-prfl') #My profile link in navbar
  click_link('new-prdt') #New product link
  # Ensure the user is on the root page
end

When("I click the \"New product\" link") do
  click_link("New Product")
end


And("I fill in the title with {string}") do |title|
  fill_in('product[title]', with: title)
end

And("I fill in the description with {string}") do |description|
  fill_in('product[description]', with: description)
end

And("I set the price to {string}") do |price|
  fill_in('product[price]', with: price)
end

And("I set the category as {string}") do |category|
  select(category, from: 'product[category]')
end
And("I set the availability to {string}") do |availability|
  fill_in('product[availability]', with: availability)
end

And("I click the {string} button") do |button_text|
  click_button(button_text)
end

Then("I should see a success message confirming the product was created") do
  expect(page).to have_content('Product was successfully created.')
end

And("I should be redirected to the product details page") do
  expect(page).to have_current_path(product_path(Product.last))
end

And("I should see the details of the newly created product, including the title, description, price, category and availability") do
  expect(page).to have_content(Product.last.title)
  expect(page).to have_content(Product.last.description)
  expect(page).to have_content(Product.last.price)
  expect(page).to have_content(Product.last.category)
  expect(page).to have_content(Product.last.availability)
end
