require 'devise'
require 'devise/test/integration_helpers'


Given("I am a logged in user and there are products for sale") do
    # Implement the logic to simulate a registered seller
    # Simulate a logged-in user which adds a new prodouct for sale
    user1 = User.create(email: 'test.user@example.com', password: 'password', nome: 'Test', cognome: 'Bianchi', città: 'Padova', roles_mask: 1, cap_residenza: '36200', via_residenza: 'Via Rossi, 2', num_telefono: '3211233344')
    visit new_user_session_path
    fill_in 'Email', with: user1.email
    fill_in 'Password', with: user1.password
    click_button 'Sign in'
    expect(page).to have_content('Signed in successfully.') # Expectation for success message
    expect(page).to have_current_path(root_path)
    click_link('my-prfl') #My profile link in navbar
    click_link('new-prdt') #New product link
    fill_in('product[title]', with: 'Product1')
    fill_in('product[description]', with: 'Test')
    fill_in('product[price]', with: '15')
    img_path = Rails.root.join('features', 'step_definitions', 'logo.png')
    attach_file('product[images][]', img_path)
    select('Chain', from: 'product[category]')
    fill_in('product[availability]', with: '2')
    click_button("Create Product")
    click_link("Logout")

    visit new_user_session_path
    user2 = User.create(email: 'test2.bianchi@example.com', password: 'password', nome: 'Marco', cognome: 'Rossi', città: 'Verona', roles_mask: 2, cap_residenza: '37100', via_residenza: 'Via Bianchi, 3', num_telefono: '3211233344' )
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
# Since it is the second cart that was created, the correct route to access it would be /carts/2.
Then("I should be redirected to my cart page") do
  expect(page).to have_current_path(cart_path(:cart_id => 2))
end

And("I should see the added product in the cart list") do
  expect(page).to have_content("#{CartItem.last.product.title}")
end

And("the quantity of the product in the cart should be 1") do
  expect(page).to have_content("x 1")
end
  