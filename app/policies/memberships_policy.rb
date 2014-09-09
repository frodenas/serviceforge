class MembershipsPolicy < ApplicationPolicy
  def create?
    admin? || team_member?
  end

  def destroy?
    admin? || team_member?
  end

  private

  def team_member?
    record.users.include?(user)
  end
end
