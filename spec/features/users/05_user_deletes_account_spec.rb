require 'rails_helper'

feature 'user deletes account' do
  # As an authenticated user
  # I want to delete my account
  # Because I no longer want to use the app
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I must visit the My Account page
  #   - I must supply my current password
  #   - Clicking Delete My Account (soft) deletes my account

  let!(:user) { create(:user) }

  scenario 'successfully delete account' do
    sign_in user
    visit edit_user_registration_path
    click_button "Delete My Account"

    expect(page).to have_content "Your account has been deleted."
    expect(page).to have_current_path root_path
  end

  scenario 'account is soft deleted' do
    sign_in user
    visit edit_user_registration_path
    click_button "Delete My Account"

    expect(User.count).to be 1
    expect(User.first.delete_at).to_not be nil
  end
end
