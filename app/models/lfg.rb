class Lfg < ApplicationRecord
  belongs_to :ownership
  has_one :user, through: :ownership
  has_one :games_console, through: :ownership
  has_one :game, through: :games_console
  has_one :console, through: :games_console

  validates :specifics, length: { maximum: 150 }
end
