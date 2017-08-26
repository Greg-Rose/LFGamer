class Admin::ConversationsController < AdminController
  def index
    @conversations = Conversation.paginate(page: params[:page], per_page: 10).order(:id)
    render layout: false
  end
end
