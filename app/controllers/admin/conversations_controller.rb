class Admin::ConversationsController < AdminController
  layout false

  def index
    @conversations = Conversation.paginate(page: params[:page], per_page: 10).order(:id)
  end
end
