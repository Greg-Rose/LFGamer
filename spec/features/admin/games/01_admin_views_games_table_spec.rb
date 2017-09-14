require 'rails_helper'

feature 'admin views games table' do
  # As an admin
  # I want to view a table of all the site's games
  # So that I can see which games are currently available on the site
  #
  # Acceptance Criteria:
  #   - I must be signed in with admin privileges
  #   - On the admin dashboard I must click the games count tab/button
  #   - I can click an x button to go back to the admin dashboard main
  #   - I can view a table that shows each games name, number of consoles, number of users, multiplayer type, created at date

  let!(:admin) { create(:user, admin: true) }
  let!(:games) { create_list(:game, 4) }

  scenario 'view games table', js: true do
    sign_in admin
    visit admin_path
    find('.games-count').click

    expect(page).to have_css ".games-table-div"
    Game.all.each do |game|
      expect(page).to have_content game.name
      expect(page).to have_content game.consoles.count
      expect(page).to have_content game.users.count
      expect(page).to have_content "Online" if game.online?
      expect(page).to have_content "Split Screen" if game.split_screen?
      expect(page).to have_content game.created_at
    end
  end
end
