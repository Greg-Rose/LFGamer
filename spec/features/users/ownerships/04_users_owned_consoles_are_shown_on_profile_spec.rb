require 'rails_helper'

feature 'users owned consoles are shown on users profile' do
  # As a user
  # I want to view a users owned consoles on their profile
  # So that I can see what consoles they own
  #
  # Acceptance Criteria:
  #   - I must visit the profile of the user
  #   - There is a Consoles section on the page
  #   - Each of the users owned consoles names are listed
  #   - If a user has no ownerships it says "#(user.username) hasn't added any consoles yet."
  #   - If you have no ownerships yours says "You haven't added any consoles yet."

  let!(:users) { create_list(:user, 3) }
  let!(:games) { create_list(:game, 3) }
  let!(:ownerships) do
    users[0].games_consoles << games[0].games_consoles.first
    users[0].games_consoles << games[1].games_consoles.first
    games.each do |game|
      users[1].games_consoles << game.games_consoles.first
    end
  end

  scenario 'users own profile shows users owned consoles' do
    sign_in users[0]
    visit profile_path(users[0].profile)

    within("div.owned-consoles") do
      expect(page).to have_content "My Consoles"
      users[0].consoles.each do |console|
        expect(page).to have_content console.name
      end
    end
  end

  scenario 'another users profile shows their owned consoles' do
    sign_in users[0]
    visit profile_path(users[1].profile)

    within("div.owned-consoles") do
      expect(page).to have_content "Consoles"
      expect(page).to_not have_content "My Consoles"
      users[1].consoles.each do |console|
        expect(page).to have_content console.name
      end
    end
  end

  scenario 'the profile of a user with no ownerships shows message' do
    sign_in users[0]
    visit profile_path(users[2].profile)

    within("div.owned-consoles") do
      expect(page).to have_content "Consoles"
      expect(page).to_not have_content "My Consoles"
      expect(page).to have_content "#{users[2].username} hasn't added any consoles yet."
    end
  end

  scenario 'when you have no ownerships, your profile shows message' do
    sign_in users[2]
    visit profile_path(users[2].profile)

    within("div.owned-consoles") do
      expect(page).to have_content "My Consoles"
      expect(page).to have_content "You haven't added any consoles yet."
    end
  end
end
