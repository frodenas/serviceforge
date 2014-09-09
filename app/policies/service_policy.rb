class ServicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      admin? ? scope.all : scope.public_services
    end
  end

  def show?
    admin? || creator? || record.public?
  end

  def create?
    logged_in?
  end

  def update?
    admin? || creator?
  end

  def destroy?
    admin? || creator?
  end

  private

  def creator?
    record.creator == user
  end
end