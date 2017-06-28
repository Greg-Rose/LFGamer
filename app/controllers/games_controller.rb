class GamesController < ApplicationController
  def index
    @consoles = Console.all
    @games = Game.all
  end
end
