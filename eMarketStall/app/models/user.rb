class User < ApplicationRecord
  has_many :products
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable, :omniauthable, omniauth_providers: [:google_oauth2]

  validates :nome, presence: true

  def admin?
    self.roles_mask==3
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
end
