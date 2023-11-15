class Coordinator < ApplicationRecord
  belongs_to :user
  has_many :projects
  has_one :address
  accepts_nested_attributes_for :address


  validates :name, :phone_number, :academic_field, presence: true
end
