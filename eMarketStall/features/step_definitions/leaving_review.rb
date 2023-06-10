Given("I am a logged in buyer") do
    # Implement the logic to simulate an authenticated buyer
    @seller = User.create(email: 'test.user@example.com', password: 'password', nome: 'Test', cognome: 'Bianchi', città: 'Padova', roles_mask: 1, cap_residenza: '37100', via_residenza: 'Via Bianchi, 3', num_telefono: '3211233344' )
    #prod = Product.create(user_id: User.last.id, title: 'Tavolo', price: 30, category: 'Wood processing', description: 'Per 4 posti a sedere', availability: 3)
    # Can attach image to a product only with this method
    visit new_user_session_path
    fill_in 'Email', with: @seller.email
    fill_in 'Password', with: @seller.password
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
  end
  
  And("I previously bought at least a product") do
    # Simulating a purchase
    product = Product.last
    cart_item = CartItem.create(product_id: product.id, cart_id: Cart.last.id, quantity: 1)
    order = Order.create(user_id: User.last.id, cart_id: Cart.last.id)
    click_link("My orders")
    expect(page).to have_content("#{product.title}")
  end
  
  When("I click on the {string} link") do |button_text|
    click_link(button_text)
  end
  
  And("I fill in the review form with a rating and comment") do
    # Implement the logic to fill in the review form with a rating and comment
    select('5', from: 'review[rating]')
    fill_in('review[content]', with: 'Amazing product')
  end
  
  #"for reviews" is for resolving conficlt with another "I click the {string} button"
  And("I click the {string} button for reviews") do |button_text|
    # Implement the logic to click the "Submit Review" button or an appropriate button
    click_button(button_text)
  end
  
  Then("I should see a success message confirming my review has been submitted") do
    # Implement the logic to verify that a success message confirms the submission of the review
    expect(page).to have_content("Review was successfully created.")

  end
  
  And("the seller's profile page should display my review") do
    # logging in with seller account and checking if there is the last review created
    click_link('Logout')
    visit new_user_session_path
    fill_in 'Email', with: @seller.email
    fill_in 'Password', with: @seller.password
    click_button 'Sign in'
    click_link('My profile')
    click_link('View how your products have been reviewed')
    last_rev = Review.last
    buyer = User.last
    expect(page).to have_selector('.card-title', text: last_rev.product.title)
    expect(page).to have_selector('.card-body .col h4', text: buyer.nome+" "+buyer.cognome)
    expect(page).to have_selector('.card-body .col-auto h5', text: last_rev.content)
  end
  