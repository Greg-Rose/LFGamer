require 'rails_helper'

describe PropagateDatabase do
  describe ".add_console" do
    it "adds a console to the database" do
      PropagateDatabase.add_console(["PlayStation 4", "PS4"])
      console = Console.first

      expect(Console.count).to be 1
      expect(console.name).to eq "PlayStation 4"
      expect(console.abbreviation).to eq "PS4"
    end
  end

  describe ".add_game" do
    it "adds a game to the database (and relavant console associations)" do
      VCR.use_cassette("propagate_database/add_game") do
        Console.create(name: "PlayStation 4", abbreviation: "PS4", igdb_id: 48)
        game = {
          "name" => "Destiny 2",
          "game_modes" => [1,2,3,5],
          "release_dates" => [{"platform" => 48}],
          "cover" => {"cloudinary_id" => "o1yenovvskchtjrl48v5"}
        }
        PropagateDatabase.add_game(game)
        saved_game = Game.first

        expect(Game.count).to be 1
        expect(saved_game.name).to eq "Destiny 2"
        expect(saved_game.consoles.count).to be 1
        expect(saved_game.consoles.first.name).to eq "PlayStation 4"
      end
    end
  end

  describe ".initial_seed" do
    it "seeds database with initial consoles and games" do
      # normally seeds 40 games, test only seeds 2 for speed
      VCR.use_cassette("propagate_database/seed_initial_games") do
        PropagateDatabase.initial_seed("2017-07-02")
        consoles = Console.all
        games = Game.all

        expect(consoles.count).to be 4
        expect(games.count).to be 2
      end
    end
  end
end
