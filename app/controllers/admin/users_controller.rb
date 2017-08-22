class Admin::UsersController < ApplicationController
  before_action :authorize_admin

  def index
    @all_users = User.paginate(page: params[:page], per_page: 10).order(:id)
    @active_accounts = User.active_accounts.count
    @deleted_accounts = User.deleted_accounts.count
    render layout: false
  end

  def show
    @user = User.find(params[:id])
    render layout: false
  end

  protected

  def authorize_admin
    if !user_signed_in? || !current_user.admin?
      redirect_to root_path, alert: "Access Denied"
    end
  end
end
