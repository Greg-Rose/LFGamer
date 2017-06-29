require 'rails_helper'

feature 'user searches for game' do
  # As a user
  # I want to search for a game
  # So that I can find the game that I’m looking for
  #
  # Acceptance Criteria:
  #   - There’s a search box at the top of the games list
  #   - I must type in the name of the game I’m searching for
  #   - Clicking Search updates the page to only show games whose name includes my search
  #   - If no games match my search, I am notified with an apology

  let!(:games) { create_list(:game, 3) }
  let!(:desired_game) { create(:game, name: "Best Game Ever") }

  scenario 'search using exact game name' do
    visit games_path
    fill_in "Search", with: "Best Game Ever"
    click_button "Search"

    expect(page).to have_content desired_game.name
    games.each { |g| expect(page).to_not have_content g.name }
  end

  scenario 'search using part of game\'s name' do
    visit games_path
    fill_in "Search", with: "Best"
    click_button "Search"

    expect(page).to have_content desired_game.name
    games.each { |g| expect(page).to_not have_content g.name }
  end

  scenario 'show multiple games if they match search' do
    visit games_path
    fill_in "Search", with: "Cool"
    click_button "Search"

    games.each { |g| expect(page).to have_content g.name }
    expect(page).to_not have_content desired_game.name
  end

  scenario 'works with case insensitivity' do
    visit games_path
    fill_in "Search", with: "gaME eVeR"
    click_button "Search"

    expect(page).to have_content desired_game.name
    games.each { |g| expect(page).to_not have_content g.name }
  end

  scenario 'show\'s apology message if no game is found' do
    visit games_path
    fill_in "Search", with: "Call of Duty"
    click_button "Search"

    expect(page).to have_content "We're sorry but we couldn't find the game you're looking for."
    expect(page).to_not have_content desired_game.name
    games.each { |g| expect(page).to_not have_content g.name }
  end
end
