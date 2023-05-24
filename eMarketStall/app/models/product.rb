class Product < ApplicationRecord
    # Associazioni
  #has_many_attached :images

  before_validation :set_published_at, on: :create

  # Validazioni
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, inclusion: { in: ['Category1', 'Category2', 'Category3'] }
  validates :availability, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :published_at, presence: true

  private
  def set_published_at
    self.published_at = Time.current
  end
end
