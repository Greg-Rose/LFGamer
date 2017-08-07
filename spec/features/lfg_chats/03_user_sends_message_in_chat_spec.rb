require 'rails_helper'

feature 'user sends message in chat' do
  # As an authenticated user with an active chat
  # I want to send a message
  # So that I can communicate with another user
  #
  # Acceptance Criteria:
  #   - I must have an active chat open on the page
  #   - I must type a message in the chat field
  #   - Hitting 'Enter'/'Return' sends my message

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

  scenario 'successfully send message', js: true do
    chat = Conversation.create(sender_id: users[0].id, recipient_id: users[1].id)
    sign_in users[0]
    visit game_path(game)
    within "#chatbox_#{chat.id}" do
      text_area = first(:css, '.chatboxtextarea').native
      text_area.send_keys('testing 1, 2, 3')
      text_area.send_keys(:return)
    end
    sleep(0.1)

    expect(Message.count).to eq 1
    expect(chat.messages.count).to eq 1
    expect(page).to have_css ".chatboxmessagecontent"
    expect(page).to have_content "testing 1, 2, 3"
  end
end
