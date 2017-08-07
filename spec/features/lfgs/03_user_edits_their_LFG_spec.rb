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
  let!(:console) { create(:console, name: "Xbox One", abbreviation: nil)}
  let!(:game) { create(:game) }
  let!(:ownerships) do
    game.consoles << console
    user.games_consoles << game.games_consoles.last
  end
  let!(:lfg) do
    Lfg.create(ownership: user.ownerships.first, specifics: "Test 1 2 3", show_console_username: true)
  end

  scenario 'successfully edit LFG' do
    sign_in user
    visit game_path(game)
    fill_in "Specifics", with: "need 3 people for..."
    click_button "Look For Group"

    expect(page).to have_content "Your LFG Has Been Updated!"
    within(".game-lfgs-list") do
      expect(page).to have_content "Xbox One"
      expect(page).to have_content "need 3 people for..."
      expect(page).to have_content user.profile.xbox_gamertag
    end
    expect(Lfg.count).to eq 1
    expect(user.lfgs.count).to eq 1
  end

  scenario 'specific is too long' do
    sign_in user
    visit game_path(game)
    too_long_specifics = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis pi"
    fill_in "Specifics", with: too_long_specifics
    click_button "Look For Group"

    expect(page).to have_content "Specifics is too long"
    expect(page).to_not have_content too_long_specifics
  end

  scenario 'lfg is deleleted and new one created when console is changed' do
    user.games_consoles << game.games_consoles.first
    lfg_id = user.lfgs.first.id

    sign_in user
    visit game_path(game)
    select(user.consoles.last.name, from: "Console")
    click_button "Look For Group"

    new_lfg_id = user.lfgs.first.id
    expect(new_lfg_id).to_not eq lfg_id
    expect(page).to have_content "Your LFG Has Been Updated!"
    within(".game-lfgs-list") do
      expect(page).to_not have_content "Xbox One"
      expect(page).to have_content user.profile.xbox_gamertag
    end
    expect(Lfg.count).to eq 1
    expect(user.lfgs.count).to eq 1
  end

  scenario 'change console and specifics too long' do
    user.games_consoles << game.games_consoles.first

    sign_in user
    visit game_path(game)
    select(user.consoles.last.name, from: "Console")
    too_long_specifics = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis pi"
    fill_in "Specifics", with: too_long_specifics
    click_button "Look For Group"

    expect(page).to have_content "Specifics is too long"
    expect(page).to_not have_content too_long_specifics
  end
end
