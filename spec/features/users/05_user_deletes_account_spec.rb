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
  #   - Clicking Delete Account (soft) deletes my account

  let!(:user) { create(:user) }

  scenario 'successfully delete account' do
    sign_in user
    visit edit_user_registration_path
    click_link "Delete My Account"
    fill_in "Current Password", with: user.password
    click_button "Delete Account"

    expect(page).to have_content "Your account has been deleted."
    expect(page).to have_current_path root_path
  end

  scenario 'account is soft deleted' do
    sign_in user
    visit edit_user_registration_path
    click_link "Delete My Account"
    fill_in "Current Password", with: user.password
    click_button "Delete Account"

    expect(User.count).to be 1
    expect(User.first.deleted_at).to_not be nil
  end

  scenario 'current password not submitted' do
    sign_in user
    visit edit_user_registration_path
    click_link "Delete My Account"
    click_button "Delete Account"

    expect(page).to have_content "Current password can't be blank"
    expect(page).to have_content "Delete My Account"
    expect(page).to have_button "Delete Account"
  end

  scenario 'incorrect current password given' do
    sign_in user
    visit edit_user_registration_path
    click_link "Delete My Account"
    fill_in "Current Password", with: "wrongpasswrd"
    click_button "Delete Account"

    expect(page).to have_content "Current password is invalid"
    expect(page).to have_content "Delete My Account"
    expect(page).to have_button "Delete Account"
  end
end
