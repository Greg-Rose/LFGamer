require 'rails_helper'

feature 'user is notified when other user leaves chat' do
  # As an authenticated user with an active chat
  # I want to be notified when the other user leaves the chat
  # So that I don't go on talking to no one
  #
  # Acceptance Criteria:
  #   - I must have an active chat with another user
  #   - The chatbox must not be minimized, so that I can see the alert
  #   - If the other user leaves the chat, I am notified
  #   - The conversation and messages are deleted from the database, but I can still view them while my chatbox is open

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

  scenario 'chatbox shows notifcation that other user has left the chat', js: true do
    chat = Conversation.create(sender_id: users[0].id, recipient_id: users[1].id)
    users[1].messages.create!(body: "what's up?", conversation: chat)
    sign_in users[0]
    visit game_path(game)

    expect(page).to_not have_content "has left the chat"

    chat.destroy

    expect(page).to have_content "#{users[1].username} has left the chat"
    expect(page).to have_content "what's up?"
    expect(Conversation.count).to be 0
    expect(Message.count).to be 0
  end
end
