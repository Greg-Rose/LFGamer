require 'rails_helper'

feature 'admin views admin dashboard' do
  # As an admin
  # I want to view the admin dashboard
  # So that I can access all of the administrative features
  #
  # Acceptance Criteria:
  #   - I must be signed in with admin privileges
  #   - An Admin link is available in the navbar user dropdown
  #   - On the dashboard page I can view:
  #     - number of users, games, consoles, ownerships, lfgs, conversations

  let!(:games) { create_list(:game, 2) }
  let!(:admin) { create(:user, admin: true) }
  let!(:user) { create(:user) }

  scenario 'admin has dashboard link available' do
    sign_in admin
    visit games_path

    expect(page).to have_link "Admin Dashboard"

    click_link "Admin Dashboard"

    expect(page).to have_current_path admin_path
    expect(page).to have_content "Administrative Dashboard"
    expect(page).to have_content "Total Users"
  end

  scenario 'non admin user can\'t access admin dashboard' do
    sign_in user
    visit games_path

    expect(page).to_not have_link "Admin Dashboard"

    visit admin_path

    expect(page).to have_current_path root_path
    expect(page).to_not have_content "Administrative Dashboard"
    expect(page).to_not have_content "Total Users"
    expect(page).to have_content "Access Denied"
  end

  scenario 'view record counts' do
    sign_in admin
    visit admin_path

    expect(page).to have_content "Total Users"
    within ".users-count" do
      expect(page).to have_content User.count
    end

    expect(page).to have_content "Total Consoles"
    within ".consoles-count" do
      expect(page).to have_content Console.count
    end

    expect(page).to have_content "Total Games"
    within ".games-count" do
      expect(page).to have_content Game.count
    end

    expect(page).to have_content "Total LFGs"
    within ".lfgs-count" do
      expect(page).to have_content Lfg.count
    end

    expect(page).to have_content "Total Ownerships"
    within ".ownerships-count" do
      expect(page).to have_content Ownership.count
    end

    expect(page).to have_content "Total Conversations"
    within ".conversations-count" do
      expect(page).to have_content Conversation.count
    end
  end
end
