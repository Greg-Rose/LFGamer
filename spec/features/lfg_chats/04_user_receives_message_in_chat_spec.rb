require 'rails_helper'

feature 'user receives message in chat' do
  # As an authenticated user with an active LFG
  # I want to reveive a message
  # When another user starts a conversation/chat with me and sends me a message
  #
  # Acceptance Criteria:
  #   - I must have an active LFG for a user to use to start a chat
  #   - I can receive the message on any page
  #   - When another user starts a conversation/chat, the chatbox appears on my screen within 3 seconds
  #   - I then receive all messages the user sends me

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

  scenario 'chatbox is opened on my screen when a user starts a chat with me', js: true do
    sign_in users[0]
    visit game_path(game)

    expect(page).to_not have_css ".chatbox"

    chat = Conversation.create(sender_id: users[1].id, recipient_id: users[0].id)
    sleep(1)

    expect(page).to have_css ".chatbox#chatbox_#{chat.id}"
    expect(Conversation.count).to be 1
  end

  scenario 'receive messages from another user', js: true do
    chat = Conversation.create(sender_id: users[1].id, recipient_id: users[0].id)
    sign_in users[0]
    visit game_path(game)

    within "#chatbox_#{chat.id}" do
      expect(page).to_not have_css ".chatboxmessagecontent"
    end

    users[1].messages.create!(body: "what's up?", conversation: chat)

    within "#chatbox_#{chat.id}" do
      expect(page).to have_css ".chatboxmessagecontent"
      expect(page).to have_content "what's up?"
    end
    expect(Message.count).to eq 1

    users[1].messages.create!(body: "you there?", conversation: chat)

    within "#chatbox_#{chat.id}" do
      expect(page).to have_content "you there?"
    end
    expect(Message.count).to eq 2
  end
end
