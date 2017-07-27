class LfgsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'lfgs'
  end
end
