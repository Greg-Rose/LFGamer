class GamesConsole < ApplicationRecord
  belongs_to :game
  belongs_to :console
  has_many :ownerships
end
