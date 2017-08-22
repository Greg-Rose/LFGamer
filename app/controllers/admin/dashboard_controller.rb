class Admin::DashboardController < ApplicationController
  before_action :authorize_admin

  def index
    @user_count = User.count
    @console_count = Console.count
    @game_count = Game.count
    @ownership_count = Ownership.count
    @lfg_count = Lfg.count
    @conversation_count = Conversation.count
  end

  protected

  def authorize_admin
    if !user_signed_in? || !current_user.admin?
      redirect_to root_path, alert: "Access Denied"
    end
  end
end
