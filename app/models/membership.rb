class Membership < ActiveRecord::Base
  belongs_to :team, touch: true
  belongs_to :user, touch: true

  before_destroy :ensure_team_has_one_member

  private

  def ensure_team_has_one_member
    errors.clear

    if team.users.count <= 1
      team.errors.add(:base, 'Unable to delete member. Teams must have at least one member')
    end

    return false if team.errors.any?
  end
end
