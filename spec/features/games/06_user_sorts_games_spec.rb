require 'rails_helper'

feature 'user sorts games' do
  # As a user
  # I want to sort the games
  # So that they are easier to browse the way I want
  #
  # Acceptance Criteria:
  #   - I must click the sort field I want to sort by
  #   - The games will be sorted by that field

  let!(:games) { create_list(:game, 3) }

  scenario 'sort by name' do
    visit games_path
    click_link "Name"

    expect(page).to have_content /#{games[0].name}.*#{games[1].name}.*#{games[2].name}/

    # check reverse sort
    click_link "Name"

    expect(page).to have_content /#{games[2].name}.*#{games[1].name}.*#{games[0].name}/
  end
end
