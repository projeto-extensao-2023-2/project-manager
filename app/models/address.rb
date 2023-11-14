class Address < ApplicationRecord
  has_one :supervisor
  has_one :coordinator
  has_one :researcher

  validates :street, :district, :complement, :postal_code, :city, :state, presence: true
end
