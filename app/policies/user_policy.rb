class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin? && user != record
  end
end
