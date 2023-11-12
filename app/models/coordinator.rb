class Coordinator < ApplicationRecord
  belongs_to :user

  validates :name, :phone_number, :academic_field, presence: true
end
