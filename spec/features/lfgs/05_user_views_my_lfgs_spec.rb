require 'rails_helper'

feature 'user views My LFGs' do
  # As an authenticated user
  # I want to view all of my LFGs
  # So that I can see which games I'm currently LFGing
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I can click the My LFGs link in the user dropdown menu in navbar
  #   - It shows each of my LFGs
  #   - Each LFG shows the game as a link, console, specifics, and when it's from
  #   - Each LFG also has a button to delete the LFG
  #   - If I have no LFGs, I am given a message

  let!(:users) { create_list(:user, 2) }
  let!(:console) { create(:console, name: "Xbox One", abbreviation: nil) }
  let!(:games) { create_list(:game, 3) }
  let!(:lfgs) do
    games.each do |game|
      game.consoles << console
      users[0].games_consoles << game.games_consoles.last
      Lfg.create(ownership: users[0].ownerships.last, specifics: "Test 1 2 3")
    end
  end

  scenario 'user has LFGS and views my lfgs' do
    sign_in users[0]
    visit lfgs_path

    within(".my-lfgs") do
      expect(page).to have_content "My LFGs"
      users[0].lfgs.each do |lfg|
        expect(page).to have_content lfg.game.name
        expect(page).to have_content lfg.console.name
        expect(page).to have_content lfg.specifics
      end
    end
  end

  scenario 'user has zero LFGS and views my lfgs' do
    sign_in users[1]
    visit lfgs_path

    within(".my-lfgs") do
      expect(page).to have_content "My LFGs"
      expect(page).to have_content "You don't have any active LFGs."
    end
  end
end
