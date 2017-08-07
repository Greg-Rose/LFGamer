class Ownership < ApplicationRecord
  belongs_to :user
  belongs_to :games_console
  has_one :game, through: :games_console
  has_one :console, through: :games_console
  has_one :lfg, dependent: :destroy

  def console_id
    console.id
  end

  def console_name
    console.name
  end
end
