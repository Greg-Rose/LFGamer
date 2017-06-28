require 'rails_helper'

feature 'user views game' do
  # As a user
  # I want to select a game from the list
  # So that I can view all of the info for that game
  #
  # Acceptance Criteria:
  #   - Clicking on a game takes me to the show page
  #   - I can view the games name, cover image, consoles, multiplayer info…

  let!(:games) { create_list(:game, 2) }

  scenario 'selects game from games#index' do
    visit games_path
    click_link games[0].name

    expect(page).to have_current_path game_path(games[0])
  end

  scenario 'shows game\'s cover image' do
    visit game_path(games[0])

    expect(page).to have_css("img[src*='test_cover.jpg']")
  end

  scenario 'shows game\'s name' do
    visit game_path(games[0])

    expect(page).to have_content games[0].name
    expect(page).to_not have_content games[1].name
  end

  scenario 'shows console availability' do
    visit game_path(games[0])

    games[0].consoles.each do |console|
      expect(page).to have_content(console.name)
    end
  end
end
