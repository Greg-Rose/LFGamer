class Api::V1::LfgsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def create
    lfg = Lfg.new(lfg_params)

    if lfg.save
      lfgs_list = lfg.games_console.lfgs.order(created_at: :desc)
      render json: {
        lfg: lfg,
        lfgs_list: render_lfgs(lfgs_list),
        console_username_type: lfg.console.username_type,
        games_console_id: lfg.games_console.id
       }, status: :created, location: api_v1_lfgs_path(lfg)
    else
      render json: :nothing, status: :not_found
    end
  end

  def update
    user = current_user
    lfg = Lfg.find(params[:id])

    if lfg.user == user
      if lfg.ownership_id != params[:lfg][:ownership_id].to_i
        # If console is changed via ownership, delete lfg and create new so that
        #  ActionCable properly removes LFG from previous console's LFG list
        new_lfg = Lfg.new(lfg_params)
        if new_lfg.save
          lfg.destroy
          lfgs_list = new_lfg.games_console.lfgs.order(created_at: :desc)
          render json: {
            lfg: new_lfg,
            lfgs_list: render_lfgs(lfgs_list),
            console_username_type: new_lfg.console.username_type,
            games_console_id: new_lfg.games_console.id
           }, status: :ok, location: api_v1_lfg_path(new_lfg)
        else
          render json: :nothing, status: :not_found
        end
      else
        if lfg.update_attributes(lfg_params)
          render json: {
            lfg: lfg,
            # console_username_type: console_username_type,
           }, status: :ok, location: api_v1_lfg_path(lfg)
        else
          render json: :nothing, status: :not_found
        end
      end
    end
  end

  def destroy
    user = current_user
    lfg = Lfg.find(params[:id])

    if lfg.user == user
      lfg.destroy
      render json: :nothing, status: :ok
    end
  end

  private

  def lfg_params
    params.require(:lfg).permit(:ownership_id, :show_console_username, :specifics)
  end

  def render_lfgs(lfgs)
    ApplicationController.render(partial: 'games/lfg', collection: lfgs)
  end
end
