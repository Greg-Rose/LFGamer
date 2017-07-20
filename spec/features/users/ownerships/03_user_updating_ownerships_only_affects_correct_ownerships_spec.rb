require 'rails_helper'

feature 'user updating ownerships only affects the correct ownerships' do
  # As an authenticated user
  # I want to update my ownerships
  # So that they accurately represent the games that I own
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I must add or update an ownership
  #   - Doing so adds or removes only the ownerships I wanted

  let!(:users) { create_list(:user, 2) }
  let!(:games) { create_list(:game, 3) }
  let!(:ownerships) do
    users[0].games_consoles << games[0].games_consoles.first
    games.each do |game|
      users[1].games_consoles << game.games_consoles.first
    end
  end

  scenario 'adding ownership only adds the desired ownership' do
    expect(Ownership.count).to eq 4
    expect(users[0].ownerships.count).to eq 1
    expect(users[1].ownerships.count).to eq 3

    sign_in users[0]
    visit game_path(games[1])
    check games[1].consoles.first.abbreviation
    click_button "Add To My Games"

    expect(page).to have_content "Your Games Have Been Updated!"
    expect(page).to have_checked_field(games[1].consoles.first.abbreviation)
    expect(Ownership.count).to be 5
    expect(users[0].ownerships.count).to eq 2
    expect(users[1].ownerships.count).to eq 3
  end

  scenario 'removing game ownership only removes desired ownership' do
    users[0].games_consoles << games[1].games_consoles.first

    expect(Ownership.count).to be 5
    expect(users[0].ownerships.count).to eq 2
    expect(users[1].ownerships.count).to eq 3

    sign_in users[0]
    visit game_path(games[1])
    uncheck games[1].consoles.first.abbreviation
    click_button "Update My Games"

    expect(page).to have_content "Your Games Have Been Updated!"
    expect(page).to have_unchecked_field(games[1].consoles.first.abbreviation)
    expect(Ownership.count).to be 4
    expect(users[0].ownerships.count).to eq 1
    expect(users[1].ownerships.count).to eq 3
  end

  scenario 'clicking Add To My Games button with no boxes check and no ownerships already owned doesn\'t affect ownerships' do
    expect(Ownership.count).to be 4
    expect(users[0].ownerships.count).to eq 1
    expect(users[1].ownerships.count).to eq 3

    sign_in users[0]
    visit game_path(games[1])

    expect(page).to have_unchecked_field(games[1].consoles.first.abbreviation)

    click_button "Add To My Games"

    expect(page).to_not have_content "Your Games Have Been Updated!"
    expect(page).to have_unchecked_field(games[1].consoles.first.abbreviation)
    expect(Ownership.count).to be 4
    expect(users[0].ownerships.count).to eq 1
    expect(users[1].ownerships.count).to eq 3
  end
end
