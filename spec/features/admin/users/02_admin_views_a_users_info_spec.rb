require 'rails_helper'

feature 'admin views a users info' do
  # As an admin
  # I want to view a user's info
  # So that I can access the users account info and their activity on the site if needed
  #
  # Acceptance Criteria:
  #   - I must be signed in with admin privileges
  #   - I must be on the user table section of the admin dashboard
  #   - Each user has an info button next to their username
  #   - I must click the info button for the user I want to view
  #   - I can view the users username, first name, last name, email,
  #       - number of: games, consoles, ownerships, lfgs
  #       - account status, admin status
  #   - Close user info with x or Close button

  let!(:admin) { create(:user, admin: true) }
  let!(:users) { create_list(:user, 4) }

  scenario 'view users info', js: true do
    sign_in admin
    visit admin_path
    find('.users-count').click
    find("a##{users[1].username}").click

    expect(page).to have_css ".modal"
    within ".modal" do
      expect(page).to have_content users[1].username
      expect(page).to have_content users[1].first_name
      expect(page).to have_content users[1].last_name
      expect(page).to have_content users[1].email
      within "#modal-games-count" do
        expect(page).to have_content users[1].games.count
      end

      within "#modal-consoles-count" do
        expect(page).to have_content users[1].consoles.count
      end

      within "#modal-ownerships-count" do
        expect(page).to have_content users[1].ownerships.count
      end

      within "#modal-lfgs-count" do
        expect(page).to have_content users[1].lfgs.count
      end

      if users[1].deleted_at
        expect(page).to have_css ".glyphicon-remove"
        expect(page).to have_content users[1].deleted_at.in_time_zone("Eastern Time (US & Canada)").strftime("%b %e, %Y %r EST")
      else
        expect(page).to have_css ".glyphicon-ok"
      end

      if users[1].admin?
        expect(page).to have_content "Yes"
      else
        expect(page).to have_content "No"
      end
    end
  end

  scenario 'clicking x button closes user info and goes back to users table', js: true do
    sign_in admin
    visit admin_path
    find('.users-count').click
    find("a##{users[1].username}").click
    sleep 1
    find('#userModal .close').click

    expect(page).to_not have_css "#userModal"
    expect(page).to have_css ".users-table-div"
  end
end
