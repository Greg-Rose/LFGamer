require 'rails_helper'

feature 'user creates LFG for game they own' do
  # As an authenticated user
  # I want to create an LFG for a game I own
  # So that I can find people to play it with and they can find me
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I must go to the show page of the game I want to LFG for
  #   - I must own the game
  #   - If I own the game I can see the LFG form, if not I can't
  #   - The LFG form has a select box with each console I own the game for
  #   - I must select the console I want to LFG the game for
  #   - I can add specifics for what I'm looking for/want to play
  #   - I can choose whether to show my PSN ID/Xbox Gamertag via check_box
  #   - Clicking "Look For Group" button submits the form
  #   - An LFG is created for the game and console I chose
  #   - I receive a message saying "You Are Now LFG!"

  let!(:users) { create_list(:user, 2) }
  let!(:console) { create(:console, name: "PlayStation 4", abbreviation: "PS4")}
  let!(:game) { create(:game) }
  let!(:ownership) do
    game.consoles << console
    users[0].games_consoles << game.games_consoles.last
  end

  scenario 'can\'t view LFG form if you don\'t own game' do
    sign_in users[1]
    visit game_path(game)

    expect(page).to have_button "Add To My Games"
    expect(page).to_not have_content "Create LFG"
    expect(page).to_not have_button "Look For Group"
  end

  scenario 'successfully create LFG' do
    sign_in users[0]
    visit game_path(game)
    select(users[0].consoles.last.name, from: "Console")
    fill_in "Specifics", with: "need 3 people for..."
    check "lfg_show_console_username"
    click_button "Look For Group"

    expect(page).to have_content "You Are Now LFG!"
    within(".game-lfgs-list") do
      expect(page).to have_content "LFGs"
      expect(page).to have_content "PS4"
      expect(page).to have_content "need 3 people for..."
      expect(page).to have_content users[0].profile.psn_id
    end
    expect(Lfg.count).to eq 1
    expect(users[0].lfgs.count).to eq 1
  end
end
