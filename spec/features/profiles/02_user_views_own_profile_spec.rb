require 'rails_helper'

feature 'user views own profile' do
  # As an authenticated user
  # I want to view my profile
  # So that I can see how it looks to other users
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I can access my profile from a link in the navbar
  #   - I can see my username
  #   - I can optionally see my about me description, psn id, xbox gamertag and zipcode

  let!(:user) { create(:profile).user }

  scenario 'accessible from link in navbar' do
    sign_in user
    visit games_path
    click_link "My Profile"

    expect(page).to have_current_path profile_path(user.profile)
  end

  scenario 'shows username' do
    sign_in user
    visit profile_path(user.profile)

    within ('#main-div') do
      expect(page).to have_content user.username
    end
  end

  scenario 'shows about me description' do
    sign_in user
    visit profile_path(user.profile)

    expect(page).to have_content user.profile.about_me
  end

  scenario 'shows PSN ID' do
    sign_in user
    visit profile_path(user.profile)

    expect(page).to have_content user.profile.psn_id
  end

  scenario 'shows Xbox Gamertag' do
    sign_in user
    visit profile_path(user.profile)

    expect(page).to have_content user.profile.xbox_gamertag
  end
end
