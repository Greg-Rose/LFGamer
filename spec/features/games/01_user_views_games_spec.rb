require 'rails_helper'

feature 'user views games' do
  # As a user
  # I want to view a list of games
  # So that I can see what games I can find people to play with
  #
  # Acceptance Criteria:
  #   - I can view a list of games
  #   - I can see each game’s name, cover image, and which console(s) it’s on
  #   - I can click the game to view it’s show page info

  let!(:games) { create_list(:game, 2) }

  scenario 'views list of games' do
    visit games_path

    games.each do |game|
      expect(page).to have_content game.name
    end
  end

  scenario 'shows each game\'s cover image' do
    visit games_path

    expect(page).to have_css("img[src*='test_cover.jpg']")
  end

  scenario 'shows each game\'s console availability' do
    visit games_path

    expect(page).to have_css("img[src*='test_logo.png']")
  end
end
