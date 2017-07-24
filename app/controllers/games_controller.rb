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

    sql = "SELECT lfgs . * FROM lfgs INNER JOIN ownerships
    ON lfgs . ownership_id = ownerships . id INNER JOIN games_consoles ON
    ownerships . games_console_id = games_consoles . id WHERE ownerships . user_id = ? AND games_consoles .
    game_id = ? LIMIT 1"
    @lfg = (Lfg.find_by_sql [sql, @user, @game]).first || Lfg.new
  end
end
