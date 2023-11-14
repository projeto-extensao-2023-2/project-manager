class Researcher < ApplicationRecord
  belongs_to :user
  has_one :address

  accepts_nested_attributes_for :address

  validates :name, :phone_number, :academic_field, :cv_link, :orcid_id, :academic_title, presence: true
end