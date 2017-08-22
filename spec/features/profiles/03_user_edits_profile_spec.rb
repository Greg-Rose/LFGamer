require 'rails_helper'

feature 'user edits profile' do
  # As an authenticated user
  # I want to edit my profile
  # So that I can keep it up to date for other users to view
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I can get to the edit page by clicking Edit Profile on my profile page
  #   - I can change my PSN id and/or Xbox Live Gamertag
  #   - I can choose whether my PSN and Xbox Live are shown to everyone or not
  #   - I can change my about me description
  #   - I can change my location via zipcode (5 digits)
  #   - Clicking Edit Profile button submits my changes and takes me to my profile
  #   - If I provide valid information, my profile is submitted
  #   - If I provide an invalid zipcode, I receive an error message

  let!(:user) { create(:user) }

  before(:each) do
    temp_profile = build(:profile)
    users_profile = user.profile
    users_profile.about_me = temp_profile.about_me
    users_profile.save
  end

  scenario 'access edit page via link on profile page' do
    sign_in user
    visit profile_path(user.profile)
    click_link "Edit Profile"

    expect(page).to have_current_path edit_profile_path
  end

  scenario 'successfully edit profile' do
    sign_in user
    visit edit_profile_path
    fill_in "PSN ID", with: "NewPSN"
    fill_in "Xbox Gamertag", with: "newgamerTAG"
    fill_in "About Me", with: "new description"
    fill_in "Location", with: 77777
    choose "profile_psn_id_public_true"
    choose "profile_xbox_gamertag_public_false"
    click_button "Edit Profile"

    expect(page).to have_current_path profile_path(user.profile)
    expect(page).to have_content "NewPSN"
    expect(page).to have_content "new description"
    expect(page).to have_content "77777"
    expect(page).to_not have_content "Xbox Gamertag"
    expect(page).to_not have_content "newgamerTAG"
    expect(User.first.profile.xbox_gamertag).to eq "newgamerTAG"
  end

  scenario 'invalid zipcode shows error message' do
    sign_in user
    visit edit_profile_path
    fill_in "Location", with: "test"
    click_button "Edit Profile"

    expect(page).to have_content "Edit Profile"
    expect(page).to_not have_link "Edit Profile"
    expect(page).to have_content "Zipcode must be 5 digits"

    fill_in "Location", with: 123
    click_button "Edit Profile"

    expect(page).to have_content "Edit Profile"
    expect(page).to_not have_link "Edit Profile"
    expect(page).to have_content "Zipcode must be 5 digits"

    fill_in "Location", with: 1234567
    click_button "Edit Profile"

    expect(page).to have_content "Edit Profile"
    expect(page).to_not have_link "Edit Profile"
    expect(page).to have_content "Zipcode must be 5 digits"
  end
end
