require 'rails_helper'

feature 'users owned games are shown on users profile' do
  # As a user
  # I want to view a users owned games on their profile
  # So that I can see what games they own
  #
  # Acceptance Criteria:
  #   - I must visit the profile of the user
  #   - There is a Games section on the page
  #   - Each of the users owned games are listed
  #   - Each game shows the name, cover image, and the consoles they own the game for
  #   - If a user has no ownerships it says "#(user.username) hasn't added any games yet."
  #   - If you have no ownerships yours says "You haven't added any games yet."

  let!(:users) { create_list(:user, 3) }
  let!(:games) { create_list(:game, 3) }
  let!(:ownerships) do
    users[0].games_consoles << games[0].games_consoles.first
    users[0].games_consoles << games[1].games_consoles.first
    games.each do |game|
      users[1].games_consoles << game.games_consoles.first
    end
  end

  scenario 'users own profile shows users owned games' do
    sign_in users[0]
    visit profile_path(users[0].profile)

    within("div.owned-games") do
      expect(page).to have_content "My Games"
      users[0].games.each do |game|
        within("div#owned-game-#{game.id}") do
          expect(page).to have_content game.name
          expect(page).to have_css("img[src*='test_cover.jpg']")
          game.ownerships.where(user: users[0]).each do |ownership|
            expect(page).to have_content ownership.console.abbreviation || ownership.console.name
          end
        end
      end
    end
  end

  scenario 'another users profile shows their owned consoles' do
    sign_in users[0]
    visit profile_path(users[1].profile)

    within("div.owned-games") do
      expect(page).to have_content "Games"
      expect(page).to_not have_content "My Games"
      users[1].games.each do |game|
        within("div#owned-game-#{game.id}") do
          expect(page).to have_content game.name
          expect(page).to have_css("img[src*='test_cover.jpg']")
          game.ownerships.where(user: users[1]).each do |ownership|
            expect(page).to have_content ownership.console.abbreviation || ownership.console.name
          end
        end
      end
    end
  end

  scenario 'the profile of a user with no ownerships shows message' do
    sign_in users[0]
    visit profile_path(users[2].profile)

    within("div.owned-games") do
      expect(page).to have_content "Games"
      expect(page).to_not have_content "My Games"
      expect(page).to have_content "#{users[2].username} hasn't added any games yet."
    end
  end

  scenario 'when you have no ownerships, your profile shows message' do
    sign_in users[2]
    visit profile_path(users[2].profile)

    within("div.owned-games") do
      expect(page).to have_content "My Games"
      expect(page).to have_content "You haven't added any games yet."
    end
  end
end
