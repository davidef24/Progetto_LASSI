require 'devise'
require 'devise/test/integration_helpers'


Given("I am a logged in user and there are products for sale") do
    # Implement the logic to simulate a registered seller
    # Simulate a logged-in user which adds a new prodouct for sale
    user = User.create(email: 'test.user@example.com', password: 'password', nome: 'Test', cognome: 'Bianchi', città: 'Padova')
    prod = Product.create(user_id: User.last.id, title: 'Test product', price: 19, category: 'Wood processing', description: 'Its just a test', availability: 3)
    

    visit new_user_session_path
    user2 = User.create(email: 'test2.bianchi@example.com', password: 'password', nome: 'Marco', cognome: 'Rossi', città: 'Verona')
    fill_in 'Email', with: user2.email
    fill_in 'Password', with: user2.password
    click_button 'Sign in'
    expect(page).to have_content('Signed in successfully.') # Expectation for success message
    expect(page).to have_current_path(root_path)

    #simulating our cart logic
end

When("I click the link with id {string}") do |button_text|
  click_link(button_text)
end


# In the previous step, the test user logged in and a cart was created for this session. 
# In this step, we want to navigate to the user's cart.
# Since it is the first cart that was created, the correct route to access it would be /carts/1.
Then("I should be redirected to my cart page") do
  expect(page).to have_current_path(cart_path(:cart_id => 1))
end

And("I should see the added product in the cart list") do
  expect(page).to have_content("Item: #{CartItem.last.product.title}")
end

And("the quantity of the product in the cart should be 1") do
  expect(page).to have_content("Quantity: 1")
end
  