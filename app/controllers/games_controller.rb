class GamesController < ApplicationController
  def index
    filter = params[:console]
    search = params[:search]
    @consoles = Console.all
    @games = Game.browse(search, filter).order(last_release_date: :desc).paginate(page: params[:page], per_page: 20)
  end

  def show
    @game = Game.find(params[:id])
    @user = current_user if current_user

    sql = "SELECT lfgs . * FROM lfgs INNER JOIN ownerships
    ON lfgs . ownership_id = ownerships . id INNER JOIN games_consoles ON
    ownerships . games_console_id = games_consoles . id WHERE ownerships . user_id = ? AND games_consoles .
    game_id = ? LIMIT 1"
    @lfg = (Lfg.find_by_sql [sql, @user, @game]).first || Lfg.new
    @lfgs = @lfg.games_console.lfgs.order(created_at: :desc) if @lfg.persisted?
  end
end
