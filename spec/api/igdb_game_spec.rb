require 'rails_helper'

describe IGDB::Game do
  describe ".search" do
    it "searches for game and returns data based on search, filters, etc." do
      VCR.use_cassette("game/search") do
        games = IGDB::Game.search("destiny", nil, ["[release_dates.date][lt]=2017-06-28"], 1, 0)

        expect(games.class).to be Array
        expect(games.size).to be 1
        expect(games[0].class).to be Hash
        expect(games[0]["name"]).to_not be nil
        expect(games[0]["release_dates"]).to_not be nil
        expect(games[0]["cover"]).to_not be nil
        expect(games[0]["game_modes"]).to_not be nil
      end
    end
  end

  describe ".all" do
    it "returns games based on filters, order, limit, offset" do
      VCR.use_cassette("game/all") do
        games = IGDB::Game.all("name", nil, nil, 4, 0)

        expect(games.class).to be Array
        expect(games.size).to be 4
        expect(games[0].class).to be Hash
        expect(games[0]["name"]).to_not be nil
        expect(games[0]["release_dates"]).to be nil
      end
    end
  end

  describe ".find" do
    it "returns a game based on the game's id from api" do
      VCR.use_cassette("game/find") do
        game = IGDB::Game.find(25657)

        expect(game.class).to be Array
        expect(game.size).to be 1
        expect(game[0].class).to be Hash
        expect(game[0]["name"]).to_not be nil
        expect(game[0]["name"]).to eq "Destiny 2"
      end
    end
  end
end
