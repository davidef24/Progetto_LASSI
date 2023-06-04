Given("I am a logged in user and have a product in the cart") do
    visit new_user_session_path
    user = User.create(email: 'test.user@example.com', password: 'password', nome: 'Test', cognome: 'Bianchi', città: 'Padova')

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Accedi'
    expect(page).to have_content('Signed in successfully.') # Expectation for success message
    expect(page).to have_current_path(root_path)
    click_link("New Product")
    fill_in('product[title]', with: 'Product1')
    fill_in('product[description]', with: 'Test')
    fill_in('product[price]', with: '15')
    select('Collane', from: 'product[category]')
    fill_in('product[availability]', with: '2')
    click_button("Create Product")
    click_link("Logout")


    visit new_user_session_path
    user = User.create(email: 'test2.bianchi@example.com', password: 'password', nome: 'Marco', cognome: 'Rossi', città: 'Verona')
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Accedi'
    expect(page).to have_content('Signed in successfully.') # Expectation for success message
    expect(page).to have_current_path(root_path)
    click_button('Add to cart')
  end
  
  When("I click the {string} link for the product multiple times exceeding its availability") do |link_text|
    # Implement the logic to click the "Add one" button multiple times, exceeding the product availability
    # You can use a loop to click the button multiple times
    click_link(link_text) #avaialability is 2 so after this we should not be able to add any product
    click_link(link_text) 
  end
  
  Then("I should see an error message saying {string}") do |error_message|
    # Implement the logic to verify that the error message is displayed on the page
    # You can use assertions or expectations to check the presence of the error message
    expect(page).to have_content("It's not possible to add additional quantities of #{CartItem.last.product.title}. The maximum availability has been reached.")
  end
  