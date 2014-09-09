class ServicePlan < ActiveRecord::Base
  belongs_to :service
  belongs_to :creator, class_name: 'User'

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   format: { with: /\A[a-z0-9]+\Z/, message: 'only allows lowercase and numbers' }
  validates :description, presence: true
  validates :creator, presence: true

  scope :public_plans, -> { where(public: true) }
end
