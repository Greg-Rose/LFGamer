require 'rails_helper'

feature 'admin views conversations table' do
  # As an admin
  # I want to view a table of all the site's conversations
  # So that I can see who is using the chat feature
  #
  # Acceptance Criteria:
  #   - I must be signed in with admin privileges
  #   - On the admin dashboard I must click the conversations count tab/button
  #   - I can view a table that shows each conversations sender username, recipient username, message count, created at date

  let!(:admin) { create(:user, admin: true) }
  let!(:conversations) { create_list(:conversation, 4) }

  scenario 'view conversations table', js: true do
    sign_in admin
    visit admin_path
    find('.conversations-count').click

    expect(page).to have_css ".conversations-table-div"
    Conversation.all.each do |conversation|
      expect(page).to have_content conversation.sender.username
      expect(page).to have_content conversation.recipient.username
      expect(page).to have_content conversation.messages.count
      expect(page).to have_content conversation.created_at
    end
  end
end
