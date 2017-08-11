class Admin::DashboardController < ApplicationController
  before_action :authorize_user

  def index
    @user_count = User.count
    @consoles_count = Console.count
    @games_count = Game.count
    @ownership_count = Ownership.count
    @lfg_count = Lfg.count
    @conversation_count = Conversation.count
  end

  protected

  def authorize_user
    if !user_signed_in? || !current_user.admin?
      raise ActionController::RoutingError.new("Not Found")
    end
  end
end
