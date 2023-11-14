class Student < ApplicationRecord
  belongs_to :project
  has_one :address
  accepts_nested_attributes_for :address
end
