class GamesController < ApplicationController
  def index
    filter = params[:console]
    search = params[:search]
    @consoles = Console.all
    @games = Game.browse(search, filter)
  end

  def show
    @game = Game.find(params[:id])
    @user = current_user if current_user
  end
end
