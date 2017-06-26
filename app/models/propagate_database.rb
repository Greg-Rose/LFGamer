class PropagateDatabase
  def self.initial_seed
    seed_initial_consoles
    seed_initial_games
  end

  private_class_method def self.seed_initial_consoles
    starting_consoles = [
      ["PlayStation 4", "PS4"],
      ["PlayStation 3", "PS3"],
      ["Xbox One"],
      ["Xbox 360"]
    ]

    starting_consoles.each do |console|
      new_console = Console.find_or_initialize_by(name: console[0])
      if new_console.new_record?
        new_console.abbreviation = console[1] if console[1]
        new_console.save
      end
    end
  end

  private_class_method def self.seed_initial_games
    ps4_id = IGDB::Platform.search("PlayStation 4")[0]["id"]
    filters = [
      "[release_dates.platform][eq]=#{ps4_id}",
      "[game_modes][eq]=2",
      "[release_dates.date][lt]=2017-06-24",
      "[category][eq]=0",
      "[cover][exists]"
    ]
    games = IGDB::Game.all(nil, filters, "popularity:desc", nil, 40)
    multiplayer_id = 2
    split_screen_id = 4

    games.each do |game|
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

        game["release_dates"].each do |rd|
          platform = IGDB::Platform.find(rd["platform"])[0]
          console = Console.find_by(name: platform["name"])
          if console && !new_game.consoles.include?(console)
            new_game.consoles << console
          end
        end

        new_game.save
      end
    end
  end
end
