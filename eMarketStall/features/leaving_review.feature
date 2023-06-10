Feature: Leaving a review for a product previously bought

Scenario: Buyer leaves a review for a product
    Given I am a logged in buyer
    And I previously bought at least a product
    When I click on the "Leave a review" link
    And I fill in the review form with a rating and comment
    And I click the "Submit Review" button for reviews
    Then I should see a success message confirming my review has been submitted
    And the seller's profile page should display my review
