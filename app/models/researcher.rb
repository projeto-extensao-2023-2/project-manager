class Researcher < ApplicationRecord
  belongs_to :user

  validates :name, :phone_number, :academic_field, :cv_link, :orcid_id, :academic_title, presence: true
end
