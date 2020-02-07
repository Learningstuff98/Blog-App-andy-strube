require 'rails_helper'

RSpec.describe Moderator::SubblogsController, type: :controller do

  describe "subblogs#new action" do
    it "should successfully show the page" do
      user = FactoryBot.create(:user)
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
    end

    it "should redirect the non user to the log in page" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "subblog#create action" do
    it "a user should be able to make a subblog" do
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: {
        subblog: {
          name: 'cooking',
          description: 'this subblog is all about cooking'
        }
      }
      expect(response).to have_http_status(:found)
      subblog = user.subblogs.last
      expect(subblog.name).to eq("cooking")
      expect(subblog.description).to eq('this subblog is all about cooking')
      expect(subblog.user).to eq(user)
    end

    it "a user should not be able to make a subblog with empty text as name and description" do
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: {
        subblog: {
          name: '',
          description: ''
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "a non user should not be able to make a subblog" do
      post :create, params: {
        subblog: {
          name: 'cooking',
          description: 'this subblog is all about cooking'
        }
      }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "subblog#show action" do
    it "should successfully show the page for a moderator" do
      subblog = FactoryBot.create(:subblog)
      sign_in subblog.user
      get :show, params: { id: subblog.id }
      expect(response).to have_http_status(:success)
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      get :show, params: { id: subblog.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should deny access to a non moderator" do
      user = FactoryBot.create(:user)
      sign_in user
      subblog = FactoryBot.create(:subblog)
      get :show, params: { id: subblog.id }
      expect(response).to have_http_status(:unauthorized)
    end
  end

end
