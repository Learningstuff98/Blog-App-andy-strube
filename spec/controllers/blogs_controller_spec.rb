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

    it "should require that a user be signed in" do
      subblog = FactoryBot.create(:subblog)
      get :new, params: { subblog_id: subblog.id }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "blogs#create action" do
    it "should allow users to create blogs posts" do
      subblog = FactoryBot.create(:subblog)
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { subblog_id: subblog.id, blog: { title: 'blog title', content: 'blog content' } }
      expect(response).to have_http_status(:found)
      expect(subblog.blogs.length).to eq 1
      expect(subblog.blogs.first.title).to eq "blog title"
      expect(subblog.blogs.first.content).to eq "blog content"
    end

    it "should not allow a user to make an invalid blog post" do
      subblog = FactoryBot.create(:subblog)
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { subblog_id: subblog.id, blog: { title: '', content: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should require that a user be logged in to post a blog" do
      subblog = FactoryBot.create(:subblog)
      post :create, params: { subblog_id: subblog.id, blog: { title: 'blog title',  content: 'blog content' } }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "blogs#show action" do
    it "should successfully show the page" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      get :show, params: { id: blog.id, subblog_id: subblog.id }
      expect(response).to have_http_status(:success)
    end
  end

end
