class GamesController < ApplicationController
  def index
    filter = params[:console]
    search = params[:search]
    @consoles = Console.all
    if search && filter
      @games = Game.search(search).includes(:consoles).where(consoles: { id: filter })
    elsif search
      @games = Game.search(search).includes(:consoles)
    elsif filter
      @games = Game.includes(:consoles).where(consoles: { id: filter })
    else
      @games = Game.includes(:consoles)
    end
  end

  def show
    @game = Game.find(params[:id])
  end
end
