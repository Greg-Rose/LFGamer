require 'rails_helper'

feature 'admin views consoles table' do
  # As an admin
  # I want to view a table of all the site's consoles
  # So that I can see which consoles are currently available on our site
  #
  # Acceptance Criteria:
  #   - I must be signed in with admin privileges
  #   - On the admin dashboard I must click the consoles count tab/button
  #   - I can click an x button to go back to the admin dashboard main
  #   - I can view a table that shows each consoles name, abbreviation, created at date

  let!(:admin) { create(:user, admin: true) }
  let!(:consoles) { create_list(:console, 4) }

  scenario 'view consoles table', js: true do
    sign_in admin
    visit admin_path
    find('.consoles-count').click

    expect(page).to have_css ".consoles-table-div"
    Console.all.each do |console|
      expect(page).to have_content console.name
      expect(page).to have_content console.abbreviation
      expect(page).to have_content console.created_at
    end
  end

  scenario 'clicking x button closes consoles table and goes back to admin main', js: true do
    sign_in admin
    visit admin_path
    find('.consoles-count').click
    find('.admin-back-btn').click

    expect(page).to have_content "Administrative Dashboard"
    expect(page).to_not have_css ".consoles-table-div"
  end
end
