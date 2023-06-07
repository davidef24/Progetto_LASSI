Feature: Creating a new listing for selling a handmade creation

Scenario: Seller creates a new listing
    Given I am a logged in user and i'm in the  root page
    When I click the "New product" link
    And I fill in the title with "Handcrafted Necklace"
    And I fill in the description with "Beautiful handcrafted necklace made with genuine gemstones."
    And I set the price to "50.00"
    And I set the category as "Chains"
    And I set the availability to "3"
    And I click the "Create Product" button
    Then I should see a success message confirming the listing was created
    And I should be redirected to the listing details page
    And I should see the details of the newly created listing, including the title, description, price, category and availability