class CreateGamesConsoles < ActiveRecord::Migration[5.1]
  def change
    create_table :games_consoles do |t|
      t.belongs_to :game, index: true
      t.belongs_to :console, index: true

      t.timestamps
    end
  end
end
