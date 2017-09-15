module AddGameHelper
  def applicable_consoles(game_release_dates)
    checked_platforms = []
    consoles = []
    game_release_dates.each do |rd|
      platform_id = rd["platform"]
      if !checked_platforms.include?(platform_id)
        console = Console.find_by(igdb_id: platform_id)
        consoles << console if console
        checked_platforms << platform_id
      end
    end
    consoles.sort
  end
end
