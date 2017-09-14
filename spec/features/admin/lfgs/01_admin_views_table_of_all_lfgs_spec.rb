require 'rails_helper'

feature 'admin views lfgs table' do
  # As an admin
  # I want to view a table of all the site's lfgs
  # So that I can see which lfgs are currently on the site
  #
  # Acceptance Criteria:
  #   - I must be signed in with admin privileges
  #   - On the admin dashboard I must click the lfgs count tab/button
  #   - I can view a table that shows each lfgs username, game name, console name, specifics, created at date

  let!(:admin) { create(:user, admin: true) }
  let!(:lfgs) { create_list(:lfg, 4) }

  scenario 'view lfgs table', js: true do
    sign_in admin
    visit admin_path
    find('.lfgs-count').click

    expect(page).to have_css ".lfgs-table-div"
    Lfg.all.each do |lfg|
      expect(page).to have_content lfg.user.username
      expect(page).to have_content lfg.game.name
      expect(page).to have_content lfg.console.name
      expect(page).to have_content lfg.specifics
      expect(page).to have_content lfg.created_at
    end
  end
end
