require 'rails_helper'

RSpec.describe Moderator::CommentsController, type: :controller do
  describe "comments#destroy action" do
    it "a moderator should be able to delete comments" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      sign_in subblog.user
      delete :destroy, params: { id: comment.id, subblog_id: subblog.id, blog_id: blog.id }
      expect(response).to have_http_status(:found)
      comment = Comment.find_by_id(comment.id)
      expect(comment).to eq nil
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      delete :destroy, params: { id: comment.id, subblog_id: subblog.id, blog_id: blog.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should only allow the subblog's moderator delete someone else's comments" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      comment = FactoryBot.create(:comment)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: comment.id, subblog_id: subblog.id, blog_id: blog.id }
      comment = Comment.find_by_id(comment.id)
      expect(comment.message).to eq "comment message"
    end
  end

  describe "comments#create action" do
    it "moderators should be able to post comments from the moderator namespace" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      sign_in subblog.user
      post :create, params: { subblog_id: subblog.id, blog_id: blog.id, comment: { message: 'this is a comment' } }
      expect(response).to have_http_status(:found)
      expect(blog.comments.length).to eq 1
      expect(blog.comments.first.message).to eq "this is a comment"
    end

    it "should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      post :create, params: { subblog_id: subblog.id, blog_id: blog.id, comment: { message: 'this is a comment' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should only allow the subblog's moderator post a comment from the moderator namespace" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { subblog_id: subblog.id, blog_id: blog.id, comment: { message: 'this is a comment' } }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
