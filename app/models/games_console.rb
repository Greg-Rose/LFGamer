class GamesConsole < ApplicationRecord
  belongs_to :game
  belongs_to :console
  has_many :ownerships

  def console_name
    self.console.name
  end
end
