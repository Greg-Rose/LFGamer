class Lfg < ApplicationRecord
  after_save :broadcast_save
  after_destroy :broadcast_delete

  belongs_to :ownership
  has_one :user, through: :ownership
  has_one :games_console, through: :ownership
  has_one :game, through: :games_console
  has_one :console, through: :games_console

  validates :specifics, length: { maximum: 150 }

  def broadcast_save
    ActionCable.server.broadcast "lfgs_#{games_console.id}", status: 'saved', id: id, html: render_lfg
  end

  def broadcast_delete
    ActionCable.server.broadcast "lfgs_#{games_console.id}", status: 'deleted', id: id
  end

  private

  def render_lfg
    ApplicationController.render(partial: 'games/lfg', locals: { lfg: self })
  end
end
