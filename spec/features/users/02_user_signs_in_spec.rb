require 'rails_helper'

feature 'user signs in' do
  # As an unauthenticated user
  # I want to sign in
  # So that I can access my account and use the main features of the app
  #
  # Acceptance Criteria:
  #   - I can click Sign In from any page
  #   - I must provide my email or username
  #   - I must provide my password
  #   - If my email/username and/or password are incorrect/missing I receive an error message
  #   - If I provide valid credentials, I am signed in to my account

  let!(:user) { create(:user) }

  scenario 'successfully sign in with email' do
    visit root_path
    click_link 'Sign In'
    fill_in 'Login', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    expect(page).to have_content 'Welcome back!'
    expect(page).to have_content 'Sign Out'
    expect(page).to_not have_content 'Sign Up'
    expect(page).to_not have_content 'Sign In'
  end

  scenario 'successfully sign in with username' do
    visit new_user_session_path
    fill_in 'Login', with: user.username
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    expect(page).to have_content 'Welcome back!'
    expect(page).to have_content 'Sign Out'
    expect(page).to_not have_content 'Sign Up'
    expect(page).to_not have_content 'Sign In'
  end

  scenario 'invalid credentials' do
    visit new_user_session_path
    fill_in 'Login', with: user.email
    fill_in 'Password', with: "WrongPassword"
    click_button 'Sign In'

    expect(page).to have_content 'Invalid'
    expect(page).to have_content 'Sign In'
    expect(page).to have_content 'Sign Up'
    expect(page).to_not have_content 'Welcome back!'
    expect(page).to_not have_content 'Sign Out'
  end
end
