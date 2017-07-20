class GamesConsole < ApplicationRecord
  belongs_to :game
  belongs_to :console
  has_many :ownerships

  def console_name
    console.abbreviation || console.name
  end
end
