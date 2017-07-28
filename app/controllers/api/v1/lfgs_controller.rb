class Api::V1::LfgsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def create
    lfg = Lfg.new(lfg_params)

    if lfg.save
      render json: :nothing, status: :created, location: api_v1_lfgs_path(lfg)
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
        lfg.destroy
        lfg = Lfg.new(lfg_params)
        if lfg.save
          render json: :nothing, status: :ok, location: api_v1_lfg_path(lfg)
        else
          render json: :nothing, status: :not_found
        end
      else
        if lfg.update_attributes(lfg_params)
          render json: :nothing, status: :ok, location: api_v1_lfg_path(lfg)
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
end
