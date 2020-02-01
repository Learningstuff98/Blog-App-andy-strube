require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "users#show action" do
    it "should successfully show the page" do
      user = FactoryBot.create(:user)
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
  end
end
