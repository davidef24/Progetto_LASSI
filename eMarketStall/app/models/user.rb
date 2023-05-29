class User < ApplicationRecord
  has_many :products
  has_many :orders
  after_create :set_stripe_customer_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable, :omniauthable, omniauth_providers: [:google_oauth2]

  validates :nome, presence: true
  
 

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
