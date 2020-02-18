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
end
