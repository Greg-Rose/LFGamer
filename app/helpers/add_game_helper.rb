module AddGameHelper
  def applicable_consoles(game_release_dates)
    checked_platforms = []
    consoles = []
    game_release_dates.each do |rd|
      platform_id = rd["platform"]
      if !checked_platforms.include?(platform_id)
        platform = IGDB::Platform.find(platform_id)[0]
        console = Console.find_by(name: platform["name"])
        consoles << console if console
        checked_platforms << platform_id
      end
    end
    consoles
  end
end
