class Supervisor < ApplicationRecord
  belongs_to :user
  has_one :address
  accepts_nested_attributes_for :address
end
