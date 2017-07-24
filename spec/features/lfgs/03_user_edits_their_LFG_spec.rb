require 'rails_helper'

feature 'user edits their LFG for a game' do
  # As an authenticated user
  # I want to edit an LFG I created for a game
  # So that it properly reflects what I'm looking for
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I must go to the show page of the game
  #   - I must have already created an LFG for the game
  #   - The LFG form is filled in with my LFG info
  #   - I can edit any of the fields
  #   - I can submit my edit with the Look For Group button
  #   - I receive a message saying "Your LFG has been updated!"

  let!(:user) { create(:user) }
  let!(:console) { create(:console, name: "PlayStation 4", abbreviation: "PS4")}
  let!(:game) { create(:game) }
  let!(:ownerships) do
    game.consoles << console
    user.games_consoles << game.games_consoles.last
  end
  let!(:lfgs) do
    user.lfgs << LFG.create(ownership: users[0].ownerships.first, specifics: "Test 1 2 3", show_console_username: true)
  end

  scenario 'successfully edit LFG' do
    sign_in users[0]
    visit game_path(game)
    fill_in "Specifics", with: "need 3 people for..."
    click_button "Look For Group"

    expect(page).to have_content "Your LFG Has Been Updated!"
    within(".game-lfgs-list") do
      expect(page).to have_content "PS4"
      expect(page).to have_content "need 3 people for..."
      expect(page).to have_content users[0].profile.psn_id
    end
    expect(LFG.count).to eq 1
    expect(users[0].lfgs.count).to eq 1
  end
end
