class Console < ApplicationRecord
  has_many :games_consoles
  has_many :games, through: :games_consoles
  has_many :ownerships, through: :games_consoles
  has_many :users, -> { distinct }, through: :ownerships

  validates :name, presence: true
  validates :name, uniqueness: true
end
