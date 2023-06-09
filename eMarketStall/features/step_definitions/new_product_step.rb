require 'devise'
require 'devise/test/integration_helpers'

Given("I am a logged in user and i'm in the  root page") do
  # Implement the logic to simulate a registered seller
  # Simulate a logged-in user
  visit new_user_session_path
  #roles_mask 1 to add a new product for sale
  user = User.create(email: 'test.user@example.com', password: 'password', nome: 'Test', cognome: 'Cognome', città: 'Milano', roles_mask:1, cap_residenza: '37100', via_residenza: 'Via Bianchi, 3', num_telefono: '3211233344' )
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
  expect(page).to have_content('Signed in successfully.') # Expectation for success message
  expect(page).to have_current_path(root_path)
end

When("I click the \"New product\" link") do
  click_link('my-prfl') #My profile link in navbar
  click_link('new-prdt') #New product link
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

And("I choose images for my product") do
  img_path = Rails.root.join('features', 'step_definitions', 'logo.png')
  attach_file('product[images][]', img_path)
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
  last_prod = Product.last 
  expect(page).to have_content(last_prod.title)
  expect(page).to have_content(last_prod.description)
  expect(page).to have_content(last_prod.price)
  expect(page).to have_content(last_prod.availability)
end
