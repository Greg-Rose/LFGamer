require 'rails_helper'

feature 'user creates account' do
  # As a new user
  # I want to create an account
  # So that I can use the main features of the app
  #
  # Acceptance Criteria:
  #   - I must provide my first and last name
  #   - I must provide a username
  #   - I must provide a valid email address
  #   - I must provide a password and confirm that password
  #   - If I do not perform the above I get an error message
  #   - If I provide valid information, my account is created and I'm signed in

  scenario 'required information provided' do
    visit root_path
    click_link 'Sign Up'
    fill_in 'First Name', with: 'Malcolm'
    fill_in 'Last Name', with: 'Reynolds'
    fill_in 'Username', with: 'CaptMal'
    fill_in 'Email', with: 'mal@serenity.com'
    fill_in 'Password', with: 'firefly'
    fill_in 'Password Confirmation', with: 'firefly'
    click_button 'Sign Up'

    expect(page).to have_content 'Welcome! Thanks for signing up.'
    expect(page).to have_content 'Sign Out'
    expect(page).to_not have_content 'Sign Up'
  end

  scenario 'required information not provided' do
    visit new_user_registration_path
    click_button 'Sign Up'

    expect(page).to have_content 'can\'t be blank'
    expect(page).to_not have_content 'Sign Out'
  end

  scenario 'username already taken' do
    user = create(:user)

    visit new_user_registration_path
    fill_in 'First Name', with: 'River'
    fill_in 'Last Name', with: 'Tam'
    fill_in 'Username', with: user.username
    fill_in 'Email', with: 'RTam@firefly.com'
    fill_in 'Password', with: 'iamtheship'
    fill_in 'Password Confirmation', with: 'iamtheship'
    click_button 'Sign Up'

    expect(page).to have_content 'Sorry, that username\'s already taken.'
    expect(page).to_not have_content 'Sign Out'
  end

  scenario 'password doesn\'t match password confirmation' do
    visit new_user_registration_path
    fill_in 'First Name', with: 'Jayne'
    fill_in 'Last Name', with: 'Cobb'
    fill_in 'Username', with: 'JayneC'
    fill_in 'Email', with: 'Jayne@serenity.com'
    fill_in 'Password', with: 'orangehat'
    fill_in 'Password Confirmation', with: 'cookies'
    click_button 'Sign Up'

    expect(page).to have_content 'Password doesn\'t match'
    expect(page).to_not have_content 'Sign Out'
  end
end
