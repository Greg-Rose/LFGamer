require 'rails_helper'

feature 'admin views user table' do
  # As an admin
  # I want to view a table of all the site's users
  # So that I can see who's using the site
  #
  # Acceptance Criteria:
  #   - I must be signed in with admin privileges
  #   - On the admin dashboard I must click the users count tab/button
  #   - I can see the number of active accounts and deleted accounts
  #   - I can click an x button to go back to the admin dashboard main
  #   - I can view a table that shows each users username, name, email and account status

  let!(:admin) { create(:user, admin: true) }
  let!(:users) { create_list(:user, 4) }

  scenario 'view number of active and deleted accounts', js: true do
    sign_in admin
    visit admin_path
    find('.users-count').click

    expect(page).to_not have_content "Administrative Dashboard"
    expect(page).to have_content "Active Accounts"
    within "#active_accounts" do
      expect(page).to have_content User.active_accounts.count
    end
    expect(page).to have_content "Deleted Accounts"
    within "#deleted_accounts" do
      expect(page).to have_content User.deleted_accounts.count
    end
  end

  scenario 'view users table', js: true do
    sign_in admin
    visit admin_path
    find('.users-count').click

    expect(page).to have_css ".users-table-div"
    User.all.each do |user|
      expect(page).to have_content user.username
      expect(page).to have_content user.full_name
      expect(page).to have_content user.email
    end
  end

  scenario 'clicking x button closes users info and goes back to admin main', js: true do
    sign_in admin
    visit admin_path
    find('.users-count').click
    find('.admin-back-btn').click

    expect(page).to have_content "Administrative Dashboard"
    expect(page).to_not have_css ".users-table-div"
  end
end
