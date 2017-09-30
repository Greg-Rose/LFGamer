require 'rails_helper'

feature 'user tries to view deleted accounts profile' do
  # As a user
  # I try to view a deleted accounts profile
  # But I'm not allowed to because it's deleted
  #
  # Acceptance Criteria:
  #   - I can't view a deleted user's profile

  let!(:user) { create(:profile).user }
  let!(:deleted_user) { create(:profile).user }

  scenario 'shows username' do
    deleted_user.deleted_at = Time.now
    deleted_user.save
    sign_in user
    visit profile_path(deleted_user.profile)

    expect(page).to_not have_content deleted_user.username
    expect(page).to have_content "No Profile Found"
    expect(page).to have_current_path root_path
  end
end
