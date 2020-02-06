require 'rails_helper'

RSpec.describe SubblogsController, type: :controller do

  describe "subblogs#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "subblog#show action" do
    it "should successfully show the page" do
      subblog = FactoryBot.create(:subblog)
      get :show, params: { id: subblog.id }
      expect(response).to have_http_status(:success)
    end
  end

end
