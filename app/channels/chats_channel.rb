class ChatsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversations_#{params[:conversation_id]}"
  end

  def send_message(data)
    current_user.messages.create!(body: data['message'], conversation_id: data['conversation_id'])
  end
end
