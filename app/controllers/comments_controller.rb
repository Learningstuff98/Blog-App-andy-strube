class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  
  def create
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = @blog.comments.create(comment_params.merge(user: current_user))
    redirect_to subblog_blog_path(@subblog, @blog)
  end

  private

  def comment_params
    params.require(:comment).permit(:message)
  end

end
