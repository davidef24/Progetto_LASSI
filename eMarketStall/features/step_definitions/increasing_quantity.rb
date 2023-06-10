Given("I am a logged in user and have at least one product in the cart") do
    # Implement the logic to simulate a registered seller
    # Simulate a logged-in user which adds a new prodouct for sale
    visit new_user_session_path
    user = User.create(email: 'test.user@example.com', password: 'password', nome: 'Test', cognome: 'Bianchi', città: 'Padova', roles_mask: 1, cap_residenza: '37100', via_residenza: 'Via Bianchi, 3', num_telefono: '3211233344' )

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(page).to have_content('Signed in successfully.') # Expectation for success message
    expect(page).to have_current_path(root_path)
    click_link('my-prfl') #My profile link in navbar
    click_link('new-prdt') #New product link
    fill_in('product[title]', with: 'Product1')
    fill_in('product[description]', with: 'Test')
    fill_in('product[price]', with: '15')
    select('Chains', from: 'product[category]')
    img_path = Rails.root.join('features', 'step_definitions', 'logo.png')
    attach_file('product[images][]', img_path)
    fill_in('product[availability]', with: '2')
    click_button("Create Product")
    click_link("Logout")


    visit new_user_session_path
    user = User.create(email: 'test2.bianchi@example.com', password: 'password', nome: 'Marco', cognome: 'Rossi', città: 'Verona', roles_mask: 2, cap_residenza: '37100', via_residenza: 'Via Bianchi, 3', num_telefono: '3211233344' )
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(page).to have_content('Signed in successfully.') # Expectation for success message
    expect(page).to have_current_path(root_path)
    click_link('cart-link')

end

When("I click the {string} link for the product") do |button_text|
  @last_cart_item = CartItem.last
  @initial_quantity = @last_cart_item.quantity.to_i
  @intial_subtotal = @last_cart_item.product.price
  click_link(button_text)
end

# I know, it's not a good wat to do it but I noticed that in this context, every time I run cucumber, in this feature,
# given the fact that two users are gonna log in, two carts would be created (we create a new cart every session), so for the second user
# the correct route for going to his cart will be /carts/2
Then("the quantity of the product in the cart should increase by 1") do
    #after increasing we need the new instance of CartItem.last
    @last_cart_item_2 = CartItem.last
    updated_quantity = @last_cart_item_2.quantity.to_i
    expect(updated_quantity).to eq(@initial_quantity + 1)
end

And("the order subtotal should be updated accordingly") do
    expect(page).to have_content("Sub total: $#{@last_cart_item_2.product.price + @intial_subtotal}0")
end

  