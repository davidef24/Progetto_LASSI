class Wishlist < ApplicationRecord
  belongs_to :user
  has_many :wishlist_items
  has_many :products, through: :wishlist_items
end
