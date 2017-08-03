class ConversationsController < ApplicationController
  before_action :authenticate_user!

  layout false

  def create
    sender_id = current_user.id
    recipient_id = params[:recipient_id].to_i
    if sender_id != recipient_id
      if Conversation.between(sender_id, recipient_id).present?
        @conversation = Conversation.between(sender_id, recipient_id.to_i).first
      else
        @conversation = Conversation.new(conversation_params)
        @conversation.sender_id = sender_id
        @conversation.save
      end

      render json: { conversation_id: @conversation.id }
    else
      render json: :nothing, status: :not_found
    end
  end

  def show
    @conversation = Conversation.find(params[:id])
    @reciever = interlocutor(@conversation)
    @messages = @conversation.messages
    @message = Message.new
  end

  def check
    ids = Conversation.involving(current_user).ids
    if ids.present?
      render json: { conversation_ids: ids }
    else
      render json: :nothing, status: :not_found
    end
  end

  private

  def conversation_params
    params.permit(:recipient_id)
  end

  def interlocutor(conversation)
    current_user == conversation.recipient ? conversation.sender : conversation.recipient
  end
end
