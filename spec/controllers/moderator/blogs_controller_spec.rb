require 'rails_helper'

RSpec.describe Moderator::BlogsController, type: :controller do
  describe "blogs#show action" do
    it "should successfully show the page" do
      subblog = FactoryBot.create(:subblog)
      sign_in subblog.user
      blog = FactoryBot.create(:blog)
      get :show, params: { id: blog.id, subblog_id: subblog.id }
      expect(response).to have_http_status(:success)
    end

    it "shouldn't allow non moderator users to get to the show page" do
      subblog = FactoryBot.create(:subblog)
      user = FactoryBot.create(:user)
      sign_in user
      blog = FactoryBot.create(:blog)
      get :show, params: { id: blog.id, subblog_id: subblog.id }
      expect(response).to have_http_status(:unauthorized)
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

  describe "Blogs#edit action" do
    it "should let moderators get to the edit page for their blog posts" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      sign_in subblog.user
      get :edit, params: {
        subblog_id: subblog.id,
        id: blog.id
      }
      expect(response).to have_http_status(:success)
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      get :edit, params: {
        subblog_id: subblog.id,
        id: blog.id
      }
      expect(response).to redirect_to new_user_session_path
    end

    it "shouldn't let anyone else edit the moderators blog posts" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: {
        subblog_id: subblog.id,
        id: blog.id
      }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "blogs#update action" do
    it "should let moderators update their blog posts" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog, content: "initial content")
      sign_in subblog.user
      patch :update, params: {
        subblog_id: subblog.id,
        id: blog.id,
        blog: {
          content: "New content"
        }
      }
      expect(response).to have_http_status(:found)
      blog.reload
      expect(blog.content).to eq "New content"
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog, content: "initial content")
      patch :update, params: {
        subblog_id: subblog.id,
        id: blog.id,
        blog: {
          content: "New content"
        }
      }
      expect(response).to redirect_to new_user_session_path
    end

    it "shouldn't let a non moderator user update blog posts" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog, content: "initial content")
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: {
        subblog_id: subblog.id,
        id: blog.id,
        blog: {
          content: "New content"
        }
      }
      expect(response).to have_http_status(:unauthorized)
      blog.reload
      expect(blog.content).to eq "initial content"
    end
  end

  describe "blogs#new action" do
    it "should successfully show the page" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      sign_in subblog.user
      get :new, params: {
        subblog_id: subblog.id,
        id: blog.id
      }
      expect(response).to have_http_status(:success)
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      get :new, params: {
        subblog_id: subblog.id,
        id: blog.id
      }
      expect(response).to redirect_to new_user_session_path
    end

    it "should only let a moderator get to this new blog page" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      user = FactoryBot.create(:user)
      sign_in user
      get :new, params: {
        subblog_id: subblog.id,
        id: blog.id
      }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "Blogs#create action" do
    it "should let moderators post blogs" do
      subblog = FactoryBot.create(:subblog)
      user = FactoryBot.create(:user)
      sign_in subblog.user
      post :create, params: {
        subblog_id: subblog.id,
        blog: {
          title: 'blog title',
          content: 'blog content'
        }
      }
      expect(response).to have_http_status(:found)
      expect(subblog.blogs.length).to eq 1
      expect(subblog.blogs.first.title).to eq "blog title"
      expect(subblog.blogs.first.content).to eq "blog content"
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      user = FactoryBot.create(:user)
      post :create, params: {
        subblog_id: subblog.id,
        blog: {
          title: 'blog title',
          content: 'blog content'
        }
      }
      expect(response).to redirect_to new_user_session_path
    end

    it "should only let moderator users post blogs" do
      subblog = FactoryBot.create(:subblog)
      user = FactoryBot.create(:user)
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: {
        subblog_id: subblog.id,
        blog: {
          title: 'blog title',
          content: 'blog content'
        }
      }
      expect(response).to have_http_status(:unauthorized)
    end
  end

end
