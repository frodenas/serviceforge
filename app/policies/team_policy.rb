class TeamPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      admin? ? scope.all : scope.user_memberships(user)
    end
  end

  def show?
    admin? || team_member?
  end

  def create?
    logged_in?
  end

  def update?
    admin? || team_member?
  end

  def destroy?
    admin? || team_member?
  end

  def autocomplete_users?
    logged_in?
  end

  private

  def team_member?
    record.users.include?(user)
  end
end
