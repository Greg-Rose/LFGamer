require 'rails_helper'

RSpec.describe Api::V1::LfgsController, type: :controller do
  describe "POST /api/v1/lfgs" do
    login_user

    it "creates a new lfg" do
      lfg = build(:lfg)

      post :create, params: { lfg: lfg.attributes }

      expect(response).to have_http_status(:created)
      expect(response.header["Location"]).to match /\/api\/v1\/lfgs/
    end

    it "returns 'not_found' if validations fail" do
      too_long_specifics = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis pi"
      post :create, params: { lfg: { specifics: too_long_specifics } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /api/v1/lfgs/:id" do
    login_user

    it "updates an lfg" do
      ownership = create(:ownership, user: User.first)
      lfg = create(:lfg, ownership: ownership)
      lfg.specifics = "new specifics"

      patch :update, params: { lfg: lfg.attributes, id: lfg.id }

      expect(response).to have_http_status(:ok)
      expect(response.header["Location"]).to match /\/api\/v1\/lfgs\/#{lfg.id}/
    end

    it "returns 'not_found' if validations fail" do
      ownership = create(:ownership, user: User.first)
      lfg = create(:lfg, ownership: ownership)
      too_long_specifics = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis pi"
      lfg.specifics = too_long_specifics
      patch :update, params: { lfg: lfg.attributes, id: lfg.id }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /api/v1/lfgs/:id" do
    login_user

    it "deletes an lfg" do
      ownership = create(:ownership, user: User.first)
      lfg = create(:lfg, ownership: ownership)

      delete :destroy, params: { id: lfg.id }

      expect(response).to have_http_status(:ok)
      expect(Lfg.count).to eq 0
    end
  end
end
