class Console < ApplicationRecord
  has_many :games_consoles
  has_many :games, through: :games_consoles

  validates :name, presence: true
  validates :name, uniqueness: true
end
