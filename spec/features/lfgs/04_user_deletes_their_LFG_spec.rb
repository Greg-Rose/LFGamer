require 'rails_helper'

feature 'user deletes their LFG for a game' do
  # As an authenticated user
  # I want to delete an LFG I created for a game
  # So that it doesn't make people think I'm still LFG when I'm not
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I must go to the show page of the game
  #   - I must have already created an LFG for the game
  #   - There is a Delete LFG button next to the LFG form
  #   - Clicking Delete LFG deletes my lfg and removes it from the LFG list
  #   - I receive a message saying "Your LFG Has Been Deleted!"

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

  scenario 'successfully delete LFG' do
    sign_in users[0]
    visit game_path(game)
    click_button "Delete LFG"

    expect(page).to have_content "Your LFG Has Been Deleted!"
    within(".game-lfgs-list") do
      expect(page).to_not have_content "PS4"
      expect(page).to_not have_content "Test 1 2 3"
      expect(page).to_not have_content users[0].profile.psn_id
    end
    expect(page).to have_content "Create LFG"
    expect(LFG.count).to eq 0
    expect(users[0].lfgs.count).to eq 0
  end
end
