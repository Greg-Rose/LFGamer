class LfgsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @user = current_user
    @game = Game.find(params[:game][:id])

    sql = "SELECT lfgs . * FROM lfgs INNER JOIN ownerships
    ON lfgs . ownership_id = ownerships . id INNER JOIN games_consoles ON
    ownerships . games_console_id = games_consoles . id WHERE ownerships . user_id = ? AND games_consoles .
    game_id = ? LIMIT 1"
    @lfg = (Lfg.find_by_sql [sql, @user, @game]).first || Lfg.new(lfg_params)

    if @lfg.new_record?
      if @lfg.save
        flash[:notice] = "You Are Now LFG!"
        redirect_to @game
      else
        render "games/show"
      end
    else
      if @lfg.update_attributes(lfg_params)
        flash[:notice] = "Your LFG Has Been Updated!"
        redirect_to @game
      else
        render "games/show"
      end
    end
  end

  private

  def lfg_params
    params.require(:lfg).permit(:ownership_id, :show_console_username, :specifics)
  end
end
