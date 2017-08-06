require 'rails_helper'

feature 'user opens chat with another user' do
  # As an authenticated user with an active LFG
  # I want to open a chat with someone else who's LFGing the same game
  # So that I can talk to them and see if they want to play together
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I must have an active LFG
  #   - Clicking the chat icon on someones LFG opens a conversation/chat with the LFG's user
  #   - If I try to open a chat with myself, no chat is opened or created
  #   - If I open a chat with a user I already have a conversation with, that conversation is opened
  #   - If I open a chat with a user I don't have a conversation with, a new conversation is created

  let!(:users) { create_list(:user, 2) }
  let!(:console) { create(:console, name: "PlayStation 4", abbreviation: "PS4")}
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

  scenario 'unsuccessfully open chat with yourself', js: true do
    sign_in users[0]
    visit game_path(game)
    find(:css, "a[data-rid='#{users[0].id}']").click
    sleep(0.1)

    expect(page).to_not have_css ".chatbox"
    expect(Conversation.count).to eq 0
  end

  scenario 'successfully create new chat/conversation', js: true do
    sign_in users[0]
    visit game_path(game)
    find(:css, "a[data-rid='#{users[1].id}']").click
    sleep(0.1)

    expect(page).to have_css "#chatbox_#{Conversation.first.id}"
    expect(Conversation.count).to eq 1
  end

  scenario 'successfully open persisted chat/conversation', js: true do
    chat = Conversation.create(sender_id: users[0].id, recipient_id: users[1].id)
    message = Message.create(conversation: chat, user: users[0], body: "hey dude!")
    sign_in users[0]
    visit game_path(game)
    find(:css, "a[data-rid='#{users[1].id}']").trigger("click")
    sleep(0.1)

    expect(page).to have_css "#chatbox_#{chat.id}"
    within("#chatbox_#{chat.id}") do
      expect(page).to have_content message.body
    end
    expect(Conversation.count).to eq 1
  end
end
