class Product < ApplicationRecord
    # Associazioni
  has_many_attached :images
  has_many :reviews
  belongs_to :user
  after_create :set_stripe_product_id
  #only if price changed
  after_update :update_stripe_price_obj, if: :saved_change_to_price?

  before_validation :set_published_at, on: :create
  before_create :set_unverified

  # Validazioni
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, inclusion: { in: ['Chains', 'Vases', 'Painting', 'Plates', 'Wood processing'] }
  validates :availability, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :published_at, presence: true

  def thumbnail(i)
    return self.images[i].variant(resize: '300x300').processed
  end

  private

  def set_published_at
    self.published_at = Time.current
  end

  def set_stripe_product_id 
    product = Stripe::Product.create(name: self.title)
    # * 100 beceause Stipe amounts are in cents unit
    price = Stripe::Price.create(product: product, unit_amount: (self.price * 100).to_i, currency: 'eur')
    update(stripe_product_id: product.id, stripe_price_id: price.id)
  end

  #when prices changes, we need to create another price object
  def update_stripe_price_obj 
    price = Stripe::Price.create(product: self.stripe_product_id, unit_amount: (self.price * 100).to_i, currency: 'eur')
    # * 100 beceause Stipe amounts are in cents unit
    update(stripe_price_id: price.id)
  end

  def set_unverified
    self.verified = false
  end
end
