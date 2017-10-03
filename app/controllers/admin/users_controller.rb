class Admin::UsersController < AdminController
  layout false

  def index
    @all_users = User.paginate(page: params[:page], per_page: 10).order(:id)
    @active_accounts = User.active_accounts.count
    @deleted_accounts = User.deleted_accounts.count
  end

  def show
    @user = User.find(params[:id])
  end
end
