class AdminController < ApplicationController
  before_action :authorize_admin

  protected

  def authorize_admin
    if !user_signed_in? || !current_user.admin?
      redirect_to root_path, alert: "Access Denied"
    end
  end
end
