require 'rails_helper'

feature 'admin adds new games' do
  # As an admin
  # I want to add a new game
  # So that the game is available for users to 'own' and LFG
  #
  # Acceptance Criteria:
  #   - I must be signed in with admin privileges
  #   - On the admin dashboard I must click the games tab/button and then the Add Game button
  #   - I must type in the name of the game I'm looking to add in the search box and click the search button
  #   - I must click on the cover image for the game I want to add
  #   - Clicking it add's the game to the database

  let!(:admin) { create(:user, admin: true) }
  let!(:console) { create(:console, name: "PlayStation 4", abbreviation: "PS4", igdb_id: 48) }

  scenario 'add game', js: true do
    sign_in admin
    visit admin_path
    find('.games-count').click
    click_link 'add-game-btn'
    fill_in 'add-game-search', with: "destiny"
    VCR.use_cassette("admin/search-new-game") do
      # click_button 'search-btn'
      find('.modal #search-btn').click
      sleep 1
      VCR.use_cassette("admin/add_new_game") do
        find('#Destiny-img').click

        sleep 1
        expect(Game.count).to eq 1
        expect(find('#Destiny-overlay .text').text).to eq "Added"
      end
    end
  end
end
