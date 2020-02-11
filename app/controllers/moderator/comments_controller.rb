class Moderator::CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]

  def destroy
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.find(params[:id])
    if @subblog.user == current_user
      @comment.destroy
      #@comment.update_attribute(:message, "deleted") # maybe I'll go with this. Not sure yet
      redirect_to moderator_subblog_blog_path(@subblog, @blog)
    end
  end

end
