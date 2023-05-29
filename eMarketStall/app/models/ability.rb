class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    end
    can [:update, :destroy], Product, user_id: user.id
    can :buy, Product do |product|
      product.user_id != user.id
    end
  end
end
