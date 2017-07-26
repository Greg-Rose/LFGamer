require 'rails_helper'

feature 'user views LFGs for game' do
  # As an authenticated user
  # I want to view LFGs for a game I own
  # So that I can find people to play it with
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I must go to the show page of the game
  #   - I must own the game and have an active LFG for it
  #   - I can see an "LFGs" section of the game page
  #   - It shows each of the game's LFGs for the console I LFG'd it for
  #   - If recent enough, my LFG is listed as well
  #   - Each LFG shows a username, console, specifics, and optionally a PSN ID/Xbox Gamertag
  #   - Each LFG also has a button to Send Play Request

  let!(:users) { create_list(:user, 3) }
  let!(:console) { create(:console, name: "PlayStation 4", abbreviation: "PS4")}
  let!(:game) { create(:game) }
  let!(:ownerships) do
    game.consoles << console
    users.each do |user|
      user.games_consoles << game.games_consoles.last
    end
  end
  let!(:lfgs) do
    Lfg.create(ownership: users[0].ownerships.first, specifics: "Test 1 2 3", show_console_username: true)
    Lfg.create(ownership: users[1].ownerships.first, specifics: "Lets play...", show_console_username: true)
  end

  scenario 'user owns game but doesn\'t have active LFG for it' do
    sign_in users[2]
    visit game_path(game)

    expect(page).to have_button "Update My Games"
    expect(page).to have_button "Look For Group"
    expect(page).to_not have_content "LFGs"
    expect(page).to_not have_content users[0].username
  end

  scenario 'user can see all of the game\'s LFGs for the console they LFG\'d it for' do
    sign_in users[0]
    visit game_path(game)

    within(".game-lfgs-list") do
      expect(page).to have_content "LFGs"
      expect(page).to have_content users[0].username
      expect(page).to have_content users[0].profile.psn_id
      expect(page).to have_content "Test 1 2 3"
      expect(page).to have_content users[1].username
      expect(page).to have_content users[1].profile.psn_id
      expect(page).to have_content "Lets play..."
      expect(page).to have_button "Request"
    end
  end

  scenario 'user doesn\'t see the game\'s LFGs for other consoles' do
    user = create(:user)
    user.games_consoles << game.games_consoles.first
    Lfg.create(ownership: user.ownerships.first, specifics: "different console")

    sign_in users[0]
    visit game_path(game)

    within(".game-lfgs-list") do
      expect(page).to_not have_content user.username
      expect(page).to_not have_content user.consoles.first.name
      expect(page).to_not have_content "different console"
    end
  end
end
