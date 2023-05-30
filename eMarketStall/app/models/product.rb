class Product < ApplicationRecord
    # Associazioni
  #has_many_attached :images
  belongs_to :user
  after_create :set_stripe_product_id

  before_validation :set_published_at, on: :create
  before_create :set_unverified

  # Validazioni
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, inclusion: { in: ['Collane', 'Vasi', 'Pittura', 'Piatti', 'Lavorazione del legno'] }
  validates :availability, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :published_at, presence: true

  private

  def set_published_at
    self.published_at = Time.current
  end

  def set_stripe_product_id 
    product = Stripe::Product.create(name: self.title)
    # * 100 beceause Stipe amounts are in cents unit
    price = Stripe::Price.create(product: product, unit_amount: (self.price).to_i * 100, currency: 'eur')
    puts price
    update(stripe_product_id: product.id, stripe_price_id: price.id)
  end
  def set_unverified
    self.verified = false
  end
end
