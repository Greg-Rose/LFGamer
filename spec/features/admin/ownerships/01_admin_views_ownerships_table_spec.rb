require 'rails_helper'

feature 'admin views ownerships table' do
  # As an admin
  # I want to view a table of all the site's ownerships
  # So that I can see which games/consoles are currently owned by all of the sites users
  #
  # Acceptance Criteria:
  #   - I must be signed in with admin privileges
  #   - On the admin dashboard I must click the ownerships count tab/button
  #   - I can click an x button to go back to the admin dashboard main
  #   - I can view a table that shows each ownerships user's username, user's account status, game name, console name, created at date

  let!(:admin) { create(:user, admin: true) }
  let!(:ownerships) { create_list(:ownership, 4) }

  scenario 'view ownerships table', js: true do
    sign_in admin
    visit admin_path
    find('.ownerships-count').click

    expect(page).to have_css ".ownerships-table-div"
    Ownership.all.each do |ownership|
      expect(page).to have_content ownership.user.username
      expect(page).to have_content ownership.game.name
      expect(page).to have_content ownership.console.name
      expect(page).to have_content ownership.created_at
    end
  end
end
