require 'rails_helper'

RSpec.describe Moderator::ResponsesController, type: :controller do
  describe "response#destroy action" do
    it "should let moderators delete response comments" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      response_comment = FactoryBot.create(:response)
      sign_in subblog.user
      delete :destroy, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        id: response_comment.id 
      }
      expect(response).to have_http_status(:success)
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      response_comment = FactoryBot.create(:response)
      delete :destroy, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        id: response_comment.id 
      }
      expect(response).to redirect_to new_user_session_path
    end

    it "should only let the subblog's moderator delete responses" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      response_comment = FactoryBot.create(:response)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        id: response_comment.id 
      }
      expect(response_comment.response_message).to eq "response message"
    end
  end

  describe "response#new action" do
    it "should successfully load the page" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      response_comment = FactoryBot.create(:response)
      sign_in subblog.user
      get :new, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        id: response_comment.id
      }
      expect(response).to have_http_status(:success)
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      response_comment = FactoryBot.create(:response)
      get :new, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        id: response_comment.id
      }
      expect(response).to redirect_to new_user_session_path
    end

    it "should only let moderators get to the new response form" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      response_comment = FactoryBot.create(:response)
      user = FactoryBot.create(:user)
      sign_in user
      get :new, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        id: response_comment.id
      }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "responses#create action" do
    it "should let moderators post responses" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      sign_in subblog.user
      post :create, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        response: {
          response_message: 'this is a reply'
        }
      }
      expect(response).to have_http_status(:found)
      expect(comment.responses.length).to eq 1
      expect(comment.responses.first.response_message).to eq "this is a reply"
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
          response_message: 'this is a reply'
        }
      }
      expect(response).to redirect_to new_user_session_path
    end

    it "Should only let moderators post responses" do
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
          response_message: 'this is a reply'
        }
      }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "responses#edit action" do
    it "should successfully load the page" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      response_comment = FactoryBot.create(:response)
      sign_in subblog.user
      get :edit, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        id: response_comment.id
      }
      expect(response).to have_http_status(:success)
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      response_comment = FactoryBot.create(:response)
      get :edit, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        id: response_comment.id
      }
      expect(response).to redirect_to new_user_session_path
    end

    it "should only let moderator users get to the edit page" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      response_comment = FactoryBot.create(:response)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: {
        subblog_id: subblog.id,
        blog_id: blog.id,
        comment_id: comment.id,
        id: response_comment.id
      }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "responses#update action" do
    it "should let moderator users update their responses" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      response_comment = FactoryBot.create(:response)
      sign_in subblog.user
      post :update, params: {
        comment_id: comment.id,
        subblog_id: subblog.id,
        blog_id: blog.id,
        id: response_comment.id,
        response_comment: {
          response_message: "updated response message"
        }
      }
      response_comment.reload
      expect(response_comment.response_message).to eq "updated response message"
      expect(response).to have_http_status(:found)
    end
  end
end
