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
    it "should allow users to create blog posts" do
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

  describe "blogs#edit action" do
    it "should successfully show the page" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      sign_in blog.user
      get :edit, params: { id: blog.id, subblog_id: subblog.id }
      expect(response).to have_http_status(:success)
    end

    it "should not allow a user who didn't make the blog post get to the edit page" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: blog.id, subblog_id: subblog.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "should redirect a non user to the sign in page" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      get :edit, params: { id: blog.id, subblog_id: subblog.id }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "blogs#update action" do
    it "The user that posted the blog should be able to update it" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      sign_in blog.user
      patch :update, params: { 
        id: blog.id, 
        subblog_id: subblog.id,
        blog: {
          title: "edited title",
          content: "edited content"
        }
      }
      expect(response).to have_http_status(:found)
      blog.reload
      expect(blog.title).to eq "edited title"
      expect(blog.content).to eq "edited content"
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      patch :update, params: {
        id: blog.id, 
        subblog_id: subblog.id,
        blog: {
          title: "edited title",
          content: "edited content"
        }
      }
      expect(response).to redirect_to new_user_session_path
    end

    it "a user that didn't post the blog shouldn't be able to update it" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: {
        id: blog.id,
        subblog_id: subblog.id,
        blog: {
          title: "edited title",
          content: "edited content"
        }
      }
      blog.reload
      expect(blog.title).to eq "blog title"
      expect(blog.content).to eq "this is the blog content"
    end
  end

  describe "blogs#destroy action" do
    it "The blogs user should be able to destroy it" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      sign_in blog.user
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

    it "shouldn't allow a user that didn't post the blog to destroy it" do
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
