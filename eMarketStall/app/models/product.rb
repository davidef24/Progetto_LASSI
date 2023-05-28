class Product < ApplicationRecord
    # Associazioni
  #has_many_attached :images
  belongs_to :user

  before_validation :set_published_at, on: :create
  before_create :set_unverified

  # Validazioni
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, inclusion: { in: ['Collane', 'Vasi', 'Quadri'] }
  validates :availability, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :published_at, presence: true

  private

  def set_published_at
    self.published_at = Time.current
  end

  def set_unverified
    self.verified = false
  end
end
