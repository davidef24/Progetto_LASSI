class Ability
  include CanCan::Ability

  def initialize(user)
    can [:update, :destroy], Product, user_id: user.id
  end
end
