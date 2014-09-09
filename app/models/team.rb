class Team < ActiveRecord::Base
  enum access_levels: { read: 0, write: 1, admin: 2 }
  has_many :memberships, dependent: :delete_all
  has_many :users, through: :memberships
  has_many :grants, dependent: :delete_all
  has_many :services, through: :grants, source: :resource, source_type: 'Service'

  after_initialize :set_default_access_level, if: :new_record?

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :access_level, presence: true, inclusion: { in: self.access_levels.values }
  validates :users, presence: true

  scope :user_memberships, lambda { |user| joins(:memberships).where(memberships: { user_id: user }) }
  scope :service_grants, lambda { |service| joins(:grants).where("grants.resource_type = 'Service' AND grants.resource_id != ?", service) }

  private

  def set_default_access_level
    self.access_level ||= Team.access_levels[:read]
  end
end
