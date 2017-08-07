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
  let!(:lfg) do
    Lfg.create(ownership: user.ownerships.first, specifics: "Test 1 2 3", show_console_username: true)
  end

  scenario 'successfully delete LFG' do
    sign_in user
    visit game_path(game)
    click_link "Remove"

    expect(page).to have_content "Your LFG Has Been Removed!"
    expect(page).to_not have_css ".game-lfgs-list"
    expect(page).to have_content "Create LFG"
    expect(Lfg.count).to eq 0
    expect(user.lfgs.count).to eq 0
  end
end
