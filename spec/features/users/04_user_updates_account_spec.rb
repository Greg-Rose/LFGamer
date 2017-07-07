require 'rails_helper'

feature 'user updates account' do
  # As an authenticated user
  # I want to update my account
  # So that I can keep my information up to date and change my password
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I can change my email
  #   - I can edit my name
  #   - I can view my username
  #   - I can change my password
  #   - I must supply my current password
  #   - Clicking Update submits the changes to my account
  #   - If the update is successfull I receive a confirmation message
  #   - If something I typed in is invalid, I receive an error message

  let!(:user) { create(:user) }

  scenario 'my account shows my username' do
    sign_in user
    visit edit_user_registration_path

    expect(page).to have_content "My Account"
    expect(page).to have_content user.username
  end

  scenario 'edit name' do
    sign_in user
    visit edit_user_registration_path
    fill_in "First Name", with: "Newfirst"
    fill_in "Last Name", with: "Newlast"
    fill_in "Current Password", with: user.password
    click_button "Update"

    expect(page).to have_content "Your account has been updated"
    expect(page).to have_content "My Account"
    expect(User.first.first_name).to eq "Newfirst"
    expect(User.first.last_name).to eq "Newlast"
  end

  scenario 'change email' do
    sign_in user
    visit edit_user_registration_path
    fill_in "Email", with: "newemail@gmail.com"
    fill_in "Current Password", with: user.password
    click_button "Update"

    expect(page).to have_content "Your account has been updated"
    expect(page).to have_content "My Account"
    expect(User.first.email).to eq "newemail@gmail.com"
  end

  scenario 'change password' do
    sign_in user
    visit edit_user_registration_path
    fill_in "Password", with: "newpassword"
    fill_in "Password Confirmation", with: "newpassword"
    fill_in "Current Password", with: user.password
    click_button "Update"

    expect(page).to have_content "Your account has been updated"
    expect(page).to have_content "My Account"
  end

  scenario 'incorrect current password' do
    sign_in user
    visit edit_user_registration_path
    fill_in "First Name", with: "Newfirstname"
    fill_in "Current Password", with: "wrongpassword"
    click_button "Update"

    expect(page).to have_content "Current password is invalid"
    expect(page).to have_content "My Account"
    expect(user.first_name).to_not eq "Newfirstname"
  end

  scenario 'invalid new email' do
    sign_in user
    visit edit_user_registration_path
    fill_in "Email", with: "notanemail"
    fill_in "Current Password", with: user.password
    click_button "Update"

    expect(page).to have_content "Email is invalid"
    expect(page).to have_content "My Account"
    expect(user.email).to_not eq "notanemail"
  end
end
