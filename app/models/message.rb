class Message < ApplicationRecord
  after_save :broadcast_message

  belongs_to :conversation
  belongs_to :user

  validates_presence_of :body, :conversation_id, :user_id

  def broadcast_message
    ActionCable.server.broadcast "conversations_#{conversation_id}", html: render_message
  end

  private

  def render_message
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: self })
  end
end
