class Admin::OwnershipsController < ApplicationController
  before_action :authorize_admin

  def index
    @ownerships = Ownership.paginate(page: params[:page], per_page: 10).order(:id)
    render layout: false
  end

  protected

  def authorize_admin
    if !user_signed_in? || !current_user.admin?
      redirect_to root_path, alert: "Access Denied"
    end
  end
end
