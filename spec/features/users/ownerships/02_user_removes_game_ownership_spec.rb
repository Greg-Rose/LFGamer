require 'rails_helper'

feature 'user removes games from "My Games" that they no longer own' do
  # As an authenticated user
  # I want remove games I no longer own
  # So that they no longer are shown in My Games on my profile
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I must go to the show page of the game I want to remove
  #   - I must uncheck 1 or more consoles I no longer own the game for
  #   - Clicking "Update My Games" button submits the form
  #   - Ownerships are removed for the game for each console I chose
  #   - I receive a message saying "Your Games Have Been Updated!"

  let!(:user) { create(:user) }
  let!(:game) { create(:game) }

  scenario 'console checkbox is checked for console I own game for' do
    user.games_consoles << game.games_consoles.first
    sign_in user
    visit game_path(game)

    expect(page).to have_checked_field(game.consoles.first.abbreviation || game.consoles.first.name)
  end

  scenario 'remove game ownership' do
    user.games_consoles << game.games_consoles.first

    expect(user.ownerships.count).to be 1

    sign_in user
    visit game_path(game)
    uncheck "user_games_console_id_#{game.games_consoles.first.id}"
    click_button "Update My Games"

    expect(page).to have_current_path game_path(game)
    expect(page).to have_content "Your Games Have Been Updated!"
    expect(user.ownerships.count).to be 0
    expect(user.games.count).to be 0
    expect(user.consoles.count).to be 0
  end
end
