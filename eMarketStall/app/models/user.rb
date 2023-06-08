class User < ApplicationRecord
  has_many :products
  has_many :orders
  has_one :wishlist
  has_many_attached :images
  after_create :set_stripe_customer_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable, :omniauthable, omniauth_providers: [:google_oauth2]

  validates :nome, presence: true
  
  def admin?
    self.roles_mask==3
  end

  def thumbnail
    if self.images.length>1
      self.images.first.purge
    end
    self.images.last.variant(resize: '500x500').processed
  end

  def thumbnail_small
    self.images.last.variant(resize: '50x50').processed
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.nome = auth.info.first_name
      user.cognome = auth.info.last_name
      user.città = auth.info.city
      user.num_telefono = auth.info.phone_number
    end
  end

  private

    def set_stripe_customer_id 
      address_obj_json = { 
        city: self.città, 
        country: 'IT', 
        line1: self.via_residenza,
        postal_code: self.cap_residenza
      }
      customer = Stripe::Customer.create(
        email: self.email,
        address: address_obj_json,
        phone: self.num_telefono,
        name: self.nome
      )
      update(stripe_customer_id: customer.id)
    end
end
