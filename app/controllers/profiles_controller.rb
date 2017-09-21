class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update]
  before_action :active_account_check!, only: [:show]

  def show
    @profile = Profile.find(params[:id])
    @user = @profile.user
  end

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    new_profile = @profile.updated_at == @profile.created_at
    if @profile.update(profile_params)
      if new_profile
        flash[:notice] = "Your profile has been created!"
      else
        flash[:notice] = "Your profile has been updated!"
      end
      redirect_to @profile
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:about_me, :psn_id, :xbox_gamertag,
      :zipcode, :psn_id_public, :xbox_gamertag_public)
  end

  def active_account_check!
    @profile = Profile.find(params[:id])
    if @profile.user.deleted_at && !current_user.admin?
      redirect_to root_path, alert: "No Profile Found"
    end
  end
end
