require 'rails_helper'

feature 'user filters game searche results' do
  # As a user
  # I want to filter my game search results
  # So that I can find the game I want for my sepecific console
  #
  # Acceptance Criteria:
  #   - I must first search for the game
  #   - I must then select the console filter I want
  #   - The game search results should then be filtered by the console

  let!(:games) { create_list(:game, 3) }
  let!(:console_0) { games[0].consoles.first }
  let!(:console) { create(:console, name: "Nintendo Switch", abbreviation: "Switch")}

  scenario 'page has filter button for console' do
    visit games_path

    expect(page).to have_link "Nintendo Switch"
  end

  scenario 'filter search results' do
    visit games_path
    fill_in "search-box", with: "Cool Game"
    click_button "search-btn"
    click_link console_0.name

    expect(page).to have_content games[0].name
    expect(page).to_not have_content games[1].name
    expect(page).to_not have_content games[2].name
  end
end
