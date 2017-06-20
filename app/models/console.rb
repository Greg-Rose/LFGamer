class Console < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :logo, presence: true
end
