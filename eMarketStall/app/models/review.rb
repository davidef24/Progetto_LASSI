class Review < ApplicationRecord
    belongs_to :user
    belongs_to :product
  
    validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
    validates :content, presence: true, length: { maximum: 150 }
    validate :user_cannot_review_own_product

    def user_cannot_review_own_product
      if self.user_id == self.product.user_id
        errors.add(:user_id, "cannot review an own product")
      end
    end
  end
  