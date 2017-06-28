require 'rails_helper'

feature 'user filters games by console' do
  # As a user
  # I want to filter the list of games by console
  # So that I can see only the games available for the console I own
  #
  # Acceptance Criteria:
  #   - Above the list of games is a filter option
  #   - I can choose from a list of consoles in a dropdown box
  #   - Selecting a console updates the page to show only games for that console
  #   - I can remove the filter to view all games again

  let!(:consoles) { create_list(:console, 2) }
  let!(:game_0) { create(:game, console: consoles[0]) }
  let!(:game_1) { create(:game, console: consoles[1]) }

  scenario 'there\'s a filter for each console' do
    visit games_path

    Console.all.each do |c|
      expect(page).to have_link c.name
    end
  end

  scenario 'filters games' do
    visit games_path
    click_link console[0].name

    expect(page).to have_content game_0.name
    expect(page).to_not have_content game_1.name
  end

  scenario 'change filters' do
    visit games_path
    click_link console[0].name
    click_link console[1].name

    expect(page).to have_content game_1.name
    expect(page).to_not have_content game_0.name
  end

  scenario 'remove filters' do
    visit games_path(console: consoles[0].id)
    click_link "None"

    expect(page).to have_content game_0.name
    expect(page).to have_content game_1.name
  end
end
