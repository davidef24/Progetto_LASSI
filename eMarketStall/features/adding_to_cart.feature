Feature: Adding a new product to the cart

Scenario: Buyer adds a new product to cart
  Given I am a logged in user and there are products for sale
  When I click the link with id "cart-link" 
  Then I should be redirected to my cart page
  And I should see the added product in the cart list
  And the quantity of the product in the cart should be 1

Scenario: Buyer increases the quantity of a product in the cart
  Given I am a logged in user and have at least one product in the cart
  When I click the "Add one" link for the product
  Then the quantity of the product in the cart should increase by 1
  And the order subtotal should be updated accordingly

Scenario: Buyer exceeds product availability in the cart
  Given I am a logged in user and have a product in the cart
  When I click the "Add one" link for the product multiple times exceeding its availability
  Then I should see an error message saying "Product availability is less than your desired quantity"



