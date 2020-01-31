require 'rails_helper'

RSpec.describe BlogsController, type: :controller do

  describe "blogs#new action" do
    it "should successfully render the page" do
      subblog = FactoryBot.create(:subblog)
      user = FactoryBot.create(:user)
      sign_in user
      get :new, params: { subblog_id: subblog.id }
      expect(response).to have_http_status(:success)
    end

    it "should require that a user be sighned in" do
      subblog = FactoryBot.create(:subblog)
      get :new, params: { subblog_id: subblog.id }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "blogss#create action" do
    it "should allow users to create blogs" do
      subblog = FactoryBot.create(:subblog)
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { subblog_id: subblog.id, blog: { title: 'blog title', content: 'blog content' } }
      expect(response).to have_http_status(:found)
      expect(subblog.blogs.length).to eq 1
      expect(subblog.blogs.first.content).to eq "blog content"
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      post :create, params: { subblog_id: subblog.id, blog: { title: 'blog title',  content: 'blog content' } }
      expect(response).to redirect_to new_user_session_path
    end
  end

end
