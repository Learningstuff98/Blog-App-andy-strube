require 'rails_helper'

RSpec.describe ResponsesController, type: :controller do
  describe "responses#new action" do
    it "should successfully show the page" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      user = FactoryBot.create(:user)
      sign_in user
      get :new, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id
      }
      expect(response).to have_http_status(:success)
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      get :new, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id
      }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "responses#create action" do
    it "should allow users to successfully create responses" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        response: {
          response_message: 'response message'
        }
      }
      expect(response).to have_http_status(:found)
      expect(comment.responses.last.response_message).to eq "response message"
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      post :create, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        response: {
          response_message: 'response message'
        }
      }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "responses#show action" do
    it "should work" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      response_comment = FactoryBot.create(:response)
      sign_in response_comment.user
      get :show, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        id: response_comment.id
      }
      expect(response).to have_http_status(:success)
    end
  end

  describe "responses#destroy action" do
    it "should let the response's user delete it" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      comment_response = FactoryBot.create(:response)
      sign_in comment_response.user
      delete :destroy, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        id: comment_response.id
      }
      expect(response).to have_http_status(:success)
      comment_response = Response.find_by_id(comment_response.id)
      expect(comment_response).to eq nil
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      comment_response = FactoryBot.create(:response)
      delete :destroy, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        id: comment_response.id
      }
      expect(response).to redirect_to new_user_session_path
    end

    it "should only let the response's user delete it" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      comment_response = FactoryBot.create(:response)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        id: comment_response.id
      }
      comment_response.reload
      expect(comment_response.response_message).to eq "response message"
    end
  end
end
