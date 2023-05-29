class Order < ApplicationRecord
    has_many :cart_items, dependent: :destroy
    belongs_to :user
end
