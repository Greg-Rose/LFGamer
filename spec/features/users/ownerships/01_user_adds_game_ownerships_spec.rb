require 'rails_helper'

feature 'user adds games they own to "My Games"' do
  # As an authenticated user
  # I want select games I own
  # So that they are added to My Games on my profile
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I must go to the show page of the game I want to add
  #   - There's a form there with a checkbox for each console the game is available on
  #   - I must choose 1 or more consoles I own the game for
  #   - Clicking "Add to My Games" button submits the form
  #   - Ownerships are created for the game for each console I chose
  #   - I receive a message saying "Your Games Have Been Updated!"

  let!(:user) { create(:user) }
  let!(:game) { create(:game) }
  let!(:consoles) { game.consoles << create_list(:console, 2) }

  scenario 'game show page form has checkbox for each console available' do
    sign_in user
    visit game_path(game)

    expect(game.consoles.count).to be 3
    game.consoles.each do |console|
      expect(page).to have_unchecked_field(console.abbreviation || console.name)
    end
  end

  scenario 'add game ownership for one console' do
    sign_in user
    visit game_path(game)
    check "user_games_console_ids_#{game.games_consoles.all[1].id}"
    click_button "Add To My Games"

    expect(page).to have_current_path game_path(game)
    expect(page).to have_content "Your Games Have Been Updated!"
    expect(user.ownerships.count).to be 1
    expect(user.games.first).to eq game
    expect(user.consoles.first).to eq game.games_consoles.all[1].console
  end

  scenario 'add game ownership for multiple consoles' do
    sign_in user
    visit game_path(game)
    game.games_consoles.each do |games_console|
      check "user_games_console_ids_#{games_console.id}"
    end
    click_button "Add To My Games"

    expect(page).to have_current_path game_path(game)
    expect(page).to have_content "Your Games Have Been Updated!"
    expect(user.ownerships.count).to be 3
    expect(user.games.count).to be 1
    expect(user.consoles.count).to be 3
    expect(user.games.first).to eq game
    game.consoles.each do |console|
      expect(user.consoles.all.include?(console)).to be true
    end
  end
end
