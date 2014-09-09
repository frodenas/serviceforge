class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  enum roles: { regular: 0, admin: 1 }
  has_many :memberships, dependent: :restrict_with_error
  has_many :teams, through: :memberships

  before_validation :set_default_role, if: :new_record?

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true, inclusion: { in: self.roles.values }

  scope :search, lambda { |search| where('first_name LIKE ? OR last_name LIKE ?', "%#{search}%", "%#{search}%") }

  private

  def set_default_role
    self.role ||= User.roles[:regular]
  end
end
