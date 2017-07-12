class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:edit]

  def edit
    @profile = current_user.profile
  end
end
