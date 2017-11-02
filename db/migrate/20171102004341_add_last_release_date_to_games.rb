class AddLastReleaseDateToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :last_release_date, :datetime
    Game.all.each do |game|
      release_dates = game.games_consoles.order(release_date: :desc).pluck(:release_date)
      game.update_attributes(last_release_date: release_dates.first)
    end
  end
end
