# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    if user.admin?
      can :manage, Category
    elsif user.staff?
      can [:read], Category
    elsif user.customers?
      can :read, Category
    end
  end
end
