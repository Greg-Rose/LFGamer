class GamesController < ApplicationController
  def index
    @consoles = Console.all
    if params[:console]
      @games = Game.includes(:consoles).where(consoles: { id: params[:console] })
    elsif params[:search]
      @games = Game.search(params[:search])
    else
      @games = Game.includes(:consoles)
    end
  end

  def show
    @game = Game.find(params[:id])
  end
end
