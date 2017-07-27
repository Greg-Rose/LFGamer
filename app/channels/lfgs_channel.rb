class LfgsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lfgs_#{params[:lfgs_games_console_id]}"
  end
end
