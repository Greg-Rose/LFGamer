require 'rails_helper'

feature 'user closes chat with another user' do
  # As an authenticated user with an active chat
  # I want to close the chat
  # So that I'm no longer communicating with the other user
  #
  # Acceptance Criteria:
  #   - I must have an active chat open on the page
  #   - Clicking the chat's close (X) button, closes the chat and deletes the conversation and messages

  let!(:users) { create_list(:user, 2) }
  let!(:console) { create(:console)}
  let!(:game) { create(:game) }
  let!(:ownerships) do
    game.consoles << console
    users.each do |user|
      user.games_consoles << game.games_consoles.last
    end
  end
  let!(:lfgs) do
    users.each do |user|
      Lfg.create(ownership: user.ownerships.first, specifics: "Test 1 2 3", show_console_username: true)
    end
  end

  scenario 'successfully close chat/conversation', js: true do
    chat = Conversation.create(sender_id: users[0].id, recipient_id: users[1].id)
    message = Message.create(conversation: chat, user: users[0], body: "hey dude!")
    sign_in users[0]
    visit game_path(game)
    within "#chatbox_#{chat.id}" do
      find(:css, ".closeChat").click
    end
    sleep(0.1)

    expect(page).to_not have_css ".chatbox"
    expect(Conversation.count).to eq 0
  end
end
