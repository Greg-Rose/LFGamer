require 'rails_helper'

feature 'user creates profile' do
  # As an authenticated user
  # I want to create my profile
  # So that I can choose what to show other users about myself
  #
  # Acceptance Criteria:
  #   - A blank profile is created for me once I create an account
  #   - After creating an account I am taken to the edit profile page
  #   - All fields are optional
  #   - I can add my PSN id and/or Xbox Live Gamertag
  #   - I can choose whether my PSN and Xbox Live are shown to everyone or not
  #   - I can add an about me description
  #   - I can add my location via zipcode (5 digits)
  #   - If I provide valid information, my profile is submitted

  let!(:user) { create(:user) }

  scenario 'blank profile created with account creation' do
    profile = User.first.profile

    expect(profile).to_not be nil
    expect(profile.psn_id).to be nil
    expect(profile.xbox_gamertag).to be nil
    expect(profile.about_me).to be nil
    expect(profile.zipcode).to be nil
  end

  scenario 'taken to profile edit page after account creation' do
    visit new_user_registration_path
    fill_in 'First Name', with: 'Malcolm'
    fill_in 'Last Name', with: 'Reynolds'
    fill_in 'Username', with: 'CaptMal'
    fill_in 'Email', with: 'mal@serenity.com'
    fill_in 'Password', with: 'firefly'
    fill_in 'Password Confirmation', with: 'firefly'
    click_button 'Sign Up'

    expect(page).to have_current_path edit_profile_path
    expect(page).to have_content "Profile"
    expect(page).to have_field "About Me"
  end

  scenario 'create profile with all fields filled in' do
    sign_in user
    visit edit_profile_path
    fill_in "PSN ID", with: "coolname"
    fill_in "Xbox Live Gamertag", with: "CoolName"
    fill_in "About Me", with: "I like playing games, etc. etc."
    fill_in "Location", with: 11111
    choose "profile_psn_id_public_true"
    choose "profile_xbox_gamertag_public_false"
    click_button "Create Profile"

    expect(page).to have_content "Your Profile Has Been Created!"
    profile = User.first.profile
    expect(profile.psn_id).to eq "coolname"
    expect(profile.xbox_gamertag).to eq "CoolName"
    expect(profile.about_me).to eq "I like playing games, etc. etc."
    expect(profile.zipcode).to eq 11111
    expect(profile.psn_id_public).to be true
    expect(profile.xbox_gamertag_public).to be false
  end

  scenario "zipcode isn't 5 digits" do
    sign_in user
    visit edit_profile_path
    fill_in "Location", with: "Boston"
    click_button "Create Profile"

    expect(page).to have_content "Zipcode must be 5 digits"
    expect(page).to have_content "Profile"
    expect(page).to have_field "About Me"
  end
end
