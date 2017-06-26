class PropagateDatabase
  def self.initial_seed
    seed_initial_consoles
    seed_initial_games
  end

  # Adds a console to the database
  #
  # params:
  #   console = array of 1..2 strings, 1st being name and 2nd being abbreviation
  def self.add_console(console)
    new_console = Console.find_or_initialize_by(name: console[0])
    if new_console.new_record?
      new_console.abbreviation = console[1] if console[1]
      new_console.save
    end
  end

  # Adds a game to the database
  #
  # params:
  #   game = hash of game date returned from IGDB::Game
  def self.add_game(game)
    multiplayer_id = 2
    split_screen_id = 4
    name = game["name"]
    multiplayer = game["game_modes"].include?(multiplayer_id)
    split_screen = game["game_modes"].include?(split_screen_id)
    cover_image_url = "https://images.igdb.com/igdb/image/upload/t_cover_big"\
                      "/#{game['cover']['cloudinary_id']}.jpg"

    new_game = Game.find_or_initialize_by(name: name)
    if new_game.new_record?
      new_game.online = multiplayer
      new_game.split_screen = split_screen
      new_game.remote_cover_image_url = cover_image_url

      checked_platforms = []
      game["release_dates"].each do |rd|
        platform_id = rd["platform"]
        if !checked_platforms.include?(platform_id)
          platform = IGDB::Platform.find(platform_id)[0]
          console = Console.find_by(name: platform["name"])
          new_game.consoles << console if console
          checked_platforms << platform_id
        end
      end

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
  private_class_method def self.seed_initial_games
    ps4_id = IGDB::Platform.search("PlayStation 4")[0]["id"]
    multiplayer_id = 2
    # Filter by PS4, multiplayer, release date, main game(not DLC), cover image
    filters = [
      "[release_dates.platform][eq]=#{ps4_id}",
      "[game_modes][eq]=#{multiplayer_id}",
      "[release_dates.date][lt]=2017-06-24",
      "[category][eq]=0",
      "[cover][exists]"
    ]
    games = IGDB::Game.all(nil, filters, "popularity:desc", 40)

    games.each do |game|
      add_game(game)
    end
  end
end
