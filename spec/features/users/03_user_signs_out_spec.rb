require 'rails_helper'

feature 'user signs out' do
  # As an authenticated user
  # I want to sign out
  # So that no one can access my account
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I can click Sign Out from any page
  #   - Clicking Sign Out logs me out of my account and shows a message confirming

  let!(:user) { create(:user) }

  scenario 'successfully signed out' do
    sign_in user
    visit root_path
    click_link 'Sign Out'

    expect(page).to have_content 'Come back soon!'
    expect(page).to have_content 'Sign In'
    expect(page).to have_content 'Sign Up'
    expect(page).to_not have_content 'Sign Out'
  end
end
