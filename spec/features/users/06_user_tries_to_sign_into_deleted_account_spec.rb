require 'rails_helper'

feature 'user tries to sign into deleted account' do
  # As an unauthenticated user who previously deleted my account
  # I want to try signing into my account
  # To see if I can access it or if I'm alerted that it's deleted
  #
  # Acceptance Criteria:
  #   - I must have already deleted my account
  #   - I must try to sign in to my deleted account
  #   - Atempting to sign in gives me an error message and does not let me sign in

  let!(:user) { create(:user, deleted_at: Time.now) }

  scenario 'successfully delete account' do
    visit new_user_session_path
    fill_in 'Login', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    expect(page).to have_content "Our records show that you deleted your account."
    expect(page).to have_link "Sign In"
    expect(page).to_not have_link "Sign Out"
  end
end
