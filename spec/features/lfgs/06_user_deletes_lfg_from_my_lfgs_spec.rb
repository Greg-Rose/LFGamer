require 'rails_helper'

feature 'user deletes LFG from My LFGs' do
  # As an authenticated user
  # I want to delete one of my LFGs from My LFGs page
  # So that I can easily remove LFGs I no longer want
  #
  # Acceptance Criteria:
  #   - I must be signed in
  #   - I must be on the My LFGs page
  #   - Each LFG has a delete button
  #   - Clicking the delete button deletes that LFG
  #   - I receive a confirmation message

  let!(:user) { create(:user) }
  let!(:console) { create(:console, name: "Xbox One", abbreviation: nil) }
  let!(:games) { create_list(:game, 3) }
  let!(:lfgs) do
    games.each_with_index do |game, index|
      game.consoles << console
      user.games_consoles << game.games_consoles.last
      Lfg.create(ownership: user.ownerships.last, specifics: "Test #{index}")
    end
  end

  scenario 'user deletes LFG' do
    lfg_to_delete = user.lfgs[1]
    sign_in user
    visit lfgs_path
    find(:css, "a[data-lfgid='#{lfg_to_delete.id}']").click

    within(".my-lfgs") do
      expect(page).to_not have_content lfg_to_delete.game.name
      expect(page).to_not have_content lfg_to_delete.specifics

      User.first.lfgs.each do |lfg|
        expect(page).to have_content lfg.game.name
        expect(page).to have_content lfg.console.name
        expect(page).to have_content lfg.specifics
      end
    end
    expect(page).to have_content "Your LFG Has Been Removed!"
    expect(page).to have_current_path lfgs_path

    expect(Lfg.count).to eq(2)
    expect(User.first.lfgs.count).to eq(2)
  end
end
