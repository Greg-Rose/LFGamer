class PropagateDatabase
  def self.initial_seed(release_date = nil)
    seed_initial_consoles
    seed_initial_games(release_date)
  end

  # Adds a console to the database
  # Params:
  #   console = array of 1..2 strings, 1st being name and 2nd being abbreviation
  def self.add_console(console)
    new_console = Console.find_or_initialize_by(name: console[0])
    if new_console.new_record?
      new_console.abbreviation = console[1] if console[1]
      api_game_data = IGDB::Platform.search(new_console.name, "id,games").first
      igdb_id = api_game_data["id"]
      new_console.igdb_id = igdb_id
      new_console.save

      # check for and set any current games in app that are available for new console
      if Game.count >= 1
        all_consoles_games = api_game_data["games"]
        game_ids = Game.pluck(:igdb_id).select { |id| all_consoles_games.include?(id) }.join(",")

        games_data = IGDB::Game.find(game_ids, "release_dates.platform,release_dates.date")

        games_data.each do |gd|
          release_data = gd["release_dates"].find { |rd| rd["platform"] == new_console.igdb_id }
          if release_data
            game = Game.find_by(igdb_id: gd["id"])
            date = release_data["date"].to_s[0..9].to_i
            release_date = Time.at(date).to_datetime.in_time_zone('GMT')

            GamesConsole.create(console: new_console, game: game, release_date: release_date)

            release_dates = game.games_consoles.order(release_date: :desc).pluck(:release_date)
            game.update_attributes(last_release_date: release_dates.first)
          end
        end
      end
    end
  end

  # Adds a game to the database
  # Params:
  #   game = hash of game date returned from IGDB::Game
  def self.add_game(game)
    multiplayer_id = 2
    split_screen_id = 4
    name = game["name"]
    igdb_id = game["id"]
    multiplayer = game["game_modes"].include?(multiplayer_id)
    split_screen = game["game_modes"].include?(split_screen_id)
    cover_image_url = "https://images.igdb.com/igdb/image/upload/t_cover_big"\
                      "/#{game['cover']['cloudinary_id']}.jpg"

    new_game = Game.find_or_initialize_by(name: name)
    if new_game.new_record?
      new_game.igdb_id = igdb_id
      new_game.online = multiplayer
      new_game.split_screen = split_screen
      new_game.remote_cover_image_url = cover_image_url

      last_release_date = nil
      checked_platforms = []
      game["release_dates"].each do |rd|
        platform_id = rd["platform"]
        if !checked_platforms.include?(platform_id)
          console = Console.find_by(igdb_id: platform_id)
          if console
            date = rd["date"].to_s[0..9].to_i
            release_date = Time.at(date).to_datetime.in_time_zone('GMT')
            new_game.games_consoles.build(console: console, release_date: release_date)

            last_release_date = release_date if last_release_date == nil || release_date > last_release_date
          end
          checked_platforms << platform_id
        end
      end

      new_game.last_release_date = last_release_date

      new_game.save
    end
  end

  private_class_method def self.seed_initial_consoles
    starting_consoles = [
      ["PlayStation 4", "PS4"],
      ["PlayStation 3", "PS3"],
      ["Xbox One"],
      ["Xbox 360"]
    ]

    starting_consoles.each do |console|
      add_console(console)
    end
  end

  # Seed database with "top" 40 PS4 games
  private_class_method def self.seed_initial_games(release_date = nil)
    ps4_id = IGDB::Platform.search("PlayStation 4")[0]["id"]
    multiplayer_id = 2
    # Filter by PS4, multiplayer, release date, main game(not DLC), cover image
    filters = [
      "[release_dates.platform][eq]=#{ps4_id}",
      "[game_modes][eq]=#{multiplayer_id}",
      "[release_dates.date][lt]=#{release_date || Time.now.strftime("%Y-%m-%d")}",
      "[category][eq]=0",
      "[cover][exists]"
    ]
    games = IGDB::Game.all(nil, filters, "popularity:desc", 40)

    games.each { |game| add_game(game) }
  end
end
