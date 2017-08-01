class Console < ApplicationRecord
  has_many :games_consoles
  has_many :games, through: :games_consoles
  has_many :ownerships, through: :games_consoles
  has_many :users, -> { distinct }, through: :ownerships

  validates :name, presence: true
  validates :name, uniqueness: true

  def username_type
    if name.include?("PlayStation")
      "PSN ID"
    elsif name.include?("Xbox")
      "Xbox Gamertag"
    end
  end
end
