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

  let!(:games) { create_list(:game, 2) }
  let!(:console) { create(:console, name: "Xbox One", abbreviation: "XBOne") }
  let!(:console_0) { games[0].consoles.first }
  let!(:console_1) { games[1].consoles.first }

  scenario 'there\'s a filter for each console' do
    games[0].consoles << console
    games[0].save
    visit games_path

    Console.all.each do |c|
      expect(page).to have_link c.name
    end
  end

  scenario 'filters games' do
    visit games_path
    click_link console_0.name

    expect(page).to have_content games[0].name
    expect(page).to_not have_content games[1].name
  end

  scenario 'change filters' do
    visit games_path
    click_link console_0.name
    click_link console_1.name

    expect(page).to have_content games[1].name
    expect(page).to_not have_content games[0].name
  end

  scenario 'remove filters' do
    visit games_path(console: console_0.id)
    click_link "All"

    expect(page).to have_content games[0].name
    expect(page).to have_content games[1].name
  end
end
