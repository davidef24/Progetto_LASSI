class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    end
    can [:update, :destroy], Product, user_id: user.id
    can :buy, Product do |product|
      product.user_id != user.id && user.roles_mask != 1
    end
    if user.roles_mask==1
      can :see, Product
    end
    if user.roles_mask==2
      can :see, Cart
      can :see, Order
      can :see, Wishlist
    end
  end
end
