require 'rails_helper'

RSpec.describe Moderator::BlogsController, type: :controller do
  describe "blogs#show action" do
    it "should successfully show the page" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      get :show, params: { id: blog.id, subblog_id: subblog.id }
      expect(response).to have_http_status(:found)
    end
  end

  describe "blogs#destroy action" do
    it "The subblogs moderator should be able to destroy it" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      sign_in subblog.user
      delete :destroy, params: { id: blog.id, subblog_id: subblog.id }
      expect(response).to have_http_status(:found)
      blog = Blog.find_by_id(blog.id)
      expect(blog).to eq nil
    end

    it "Should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      delete :destroy, params: { id: blog.id, subblog_id: subblog.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "shouldn't allow a non moderator to destroy it" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: blog.id, subblog_id: subblog.id }
      blog = Blog.find_by_id(blog.id)
      expect(blog.title).to eq "blog title"
      expect(blog.content).to eq "this is the blog content"
    end
  end

end
