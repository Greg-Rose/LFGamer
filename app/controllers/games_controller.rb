class GamesController < ApplicationController
  def index
    @consoles = Console.all
    if params[:console]
      @games = Game.includes(:consoles).where(consoles: { id: params[:console] })
    else
      @games = Game.includes(:consoles)
    end
  end
end
