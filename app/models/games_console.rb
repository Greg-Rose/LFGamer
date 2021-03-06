class GamesConsole < ApplicationRecord
  belongs_to :game
  belongs_to :console
  has_many :ownerships, dependent: :destroy
  has_many :lfgs, through: :ownerships

  def console_name
    console.abbreviation || console.name
  end
end
