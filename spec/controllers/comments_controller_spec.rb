require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "comments#create action" do
    it "Should require that a user be logged in" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      post :create, params: { subblog_id: subblog.id, blog_id: blog.id, comment: { message: 'comment message' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "Users should be able to post comments" do
      subblog = FactoryBot.create(:subblog)
      blog = FactoryBot.create(:blog)
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { subblog_id: subblog.id, blog_id: blog.id, comment: { message: 'comment message' } }
      expect(response).to have_http_status(:found)
      expect(blog.comments.length).to eq 1
      expect(blog.comments.first.message).to eq "comment message"
    end
  end

end
