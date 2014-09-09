class Grant < ActiveRecord::Base
  belongs_to :team, touch: true
  belongs_to :resource, touch: true, polymorphic: true
end
