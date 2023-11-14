class Project < ApplicationRecord
  belongs_to :researcher
  belongs_to :coordinator
end
