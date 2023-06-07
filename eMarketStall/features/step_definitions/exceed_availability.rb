Given("I am a logged in user and have a product in the cart") do
    visit new_user_session_path
    user = User.create(email: 'test.user@example.com', password: 'password', nome: 'Test', cognome: 'Bianchi', città: 'Padova', roles_mask: 1)

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
    select('Chain', from: 'product[category]')
    fill_in('product[availability]', with: '2')
    click_button("Create Product")
    click_link("Logout")


    visit new_user_session_path
    user = User.create(email: 'test2.bianchi@example.com', password: 'password', nome: 'Marco', cognome: 'Rossi', città: 'Verona')
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(page).to have_content('Signed in successfully.') # Expectation for success message
    expect(page).to have_current_path(root_path)
    click_link('cart-link') #going into the crat page
  end
  
  When("I click the {string} link for the product multiple times exceeding its availability") do |link_text|
    click_link(link_text) #avaialability is 2 so after this we should not be able to add any product
    puts CartItem.last.quantity.to_s+"--------------------////////////////7"
    click_link(link_text) 
  end

  Then("the quantity of the product in the cart is not changed") do
    
  end
  
  And("I should see an error message saying {string}") do |error_message|
    # Implement the logic to verify that the error message is displayed on the page
    # You can use assertions or expectations to check the presence of the error message
    expect(page).to have_content("It's not possible to add additional quantities of #{CartItem.last.product.title}. The maximum availability has been reached.")
  end
  