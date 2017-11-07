class LfgsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create, :update, :destroy]

  def index
    @lfgs = current_user.lfgs.order(created_at: :desc)
  end
  
  def create
    @user = current_user
    @game = Game.find(params[:game][:id])

    @lfg = Lfg.new(lfg_params)

    if @lfg.save
      flash[:notice] = "You Are Now LFG!"
      redirect_to @game
    else
      render "games/show"
    end
  end

  def update
    @user = current_user
    @game = Game.find(params[:game][:id])
    @lfg = Lfg.find(params[:id])

    if @lfg.user == @user
      if @lfg.ownership_id != params[:lfg][:ownership_id].to_i
        # If console is changed via ownership, delete lfg and create new so that
        #  ActionCable properly removes LFG from previous console's LFG list
        @lfg.destroy
        @lfg = Lfg.new(lfg_params)
        if @lfg.save
          flash[:notice] = "Your LFG Has Been Updated!"
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
  end

  def destroy
    user = current_user
    lfg = Lfg.find(params[:id])
    game = lfg.game

    if lfg.user == user
      lfg.destroy
      flash[:notice] = "Your LFG Has Been Removed!"
      if params[:from] == "my_lfgs"
        redirect_to lfgs_path
      else
        redirect_to game
      end
    end
  end

  private

  def lfg_params
    params.require(:lfg).permit(:ownership_id, :show_console_username, :specifics)
  end
end
