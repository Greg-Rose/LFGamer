require 'rails_helper'

feature 'admin adds new console' do
  # As an admin
  # I want to add a new console
  # So that the console is available for users to 'own' games for
  #
  # Acceptance Criteria:
  #   - I must be signed in with admin privileges
  #   - On the admin dashboard I must click the consoles tab/button and then the Add Console button
  #   - I must type in the name of the console I'm looking to add in the search box and click the search button
  #   - I can optionally add an abbreviation for the console
  #   - I must then click the Add Console button
  #   - Clicking it add's the console to the database and updates the current games if they're available for the new console

  let!(:admin) { create(:user, admin: true) }

  scenario 'add console', js: true do
    sign_in admin
    visit admin_path
    find('.consoles-count').click
    click_link 'add-console-btn'
    fill_in 'add-console-search', with: "playstation 4"
    VCR.use_cassette("admin/search-new-console") do
      find('.modal #search-btn').click
      sleep 1
      fill_in 'add-console-abbreviation', with: "PS4"
      VCR.use_cassette("admin/add_new_console") do
        click_button 'add-console-submit-btn'
        sleep 1
        expect(Console.count).to eq 1
        expect(page).to have_content 'PlayStation 4 has been added'
      end
    end
  end
end
