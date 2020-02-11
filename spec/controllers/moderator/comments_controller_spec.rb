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
end
