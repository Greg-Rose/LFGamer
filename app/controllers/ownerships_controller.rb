class OwnershipsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @user = current_user
    @game = Game.find(params[:game][:id])

    # Games_consoles to create ownerships for
    games_console_ids = games_consoles_params["games_console_ids"]

    if games_console_ids.count > 1
      games_console_ids.each do |games_console_id|
        Ownership.find_or_create_by(user: @user, games_console_id: games_console_id)
      end
    end

    destroyed_games = false
    # Find and delete any ownerships for this user and game
    @game.games_consoles.each do |games_console|
      ownership = games_console.ownerships.find_by(user: @user)
      if ownership && !games_console_ids.include?(games_console.id.to_s)
        ownership.destroy
        destroyed_games = true
      end
    end

    flash[:notice] = "Your Games Have Been Updated!" if games_console_ids.count > 1 || destroyed_games
    redirect_to @game
  end

  private

  def games_consoles_params
    params.require(:user).permit(games_console_ids: [])
  end
end
