class Researcher < ApplicationRecord
  belongs_to :user
  has_one :address
  has_many :projects
  accepts_nested_attributes_for :projects
  accepts_nested_attributes_for :address

  validates :name, :phone_number, :academic_field, :cv_link, :orcid_id, :academic_title, presence: true
end
