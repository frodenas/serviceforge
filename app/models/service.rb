class Service < ActiveRecord::Base
  has_attached_file :image, styles: { thumbnail: ['64x64#', :png] }, :default_url => ':style/missing.png'
  enum licenses: { free: 0, commercial: 1 }
  belongs_to :creator, class_name: 'User'
  has_many :plans, class_name: 'ServicePlan', dependent: :delete_all
  has_many :grants, as: :resource, dependent: :delete_all
  has_many :teams, through: :grants

  after_initialize :set_default_license, if: :new_record?

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   format: { with: /\A[a-z0-9]+\Z/, message: 'only allows lowercase and numbers' }
  validates :description, presence: true
  validates :bindable, presence: true
  validates :license, presence: true, inclusion: { in: self.licenses.values }
  validates :creator, presence: true
  validates_with AttachmentSizeValidator, attributes: :image, :less_than => 1.megabytes
  validates_with AttachmentContentTypeValidator, attributes: :image, content_type: ['image/jpeg', 'image/gif', 'image/png']

  scope :public_services, -> { where(public: true) }

  private

  def set_default_license
    self.license ||= Service.licenses[:free]
  end
end
