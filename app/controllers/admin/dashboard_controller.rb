class Admin::DashboardController < AdminController
  def index
    @user_count = User.count
    @console_count = Console.count
    @game_count = Game.count
    @ownership_count = Ownership.count
    @lfg_count = Lfg.count
    @conversation_count = Conversation.count
  end
end
