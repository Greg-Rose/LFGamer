class AddReleaseDateToGamesConsoles < ActiveRecord::Migration[5.1]
  def change
    add_column :games_consoles, :release_date, :datetime
    games_igdb_ids = Game.pluck(:igdb_id).join(",")
    games_data = IGDB::Game.find(games_igdb_ids, "release_dates.platform,release_dates.date")
    games_data.each do |game_data|
      game = Game.find_by(igdb_id: game_data["id"])
      game_data["release_dates"].each do |rd|
        console = Console.find_by(igdb_id: rd["platform"])
        if console
          games_console = GamesConsole.find_by(game_id: game, console_id: console)
          if games_console
            date = rd["date"].to_s[0..9].to_i
            release_date = Time.at(date).to_datetime.in_time_zone('GMT')
            games_console.update_attributes(release_date: release_date)
          end
        end
      end
    end
  end
end
