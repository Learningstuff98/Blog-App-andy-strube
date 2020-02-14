class ResponsesController < ApplicationController
  before_action :authenticate_user!

  def new
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.find(params[:comment_id])
    @response = Response.new
  end

  def create
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.find(params[:comment_id])
    @response = @comment.responses.create(response_params.merge(user: current_user))
    redirect_to subblog_blog_path(@subblog, @blog)
  end

  private

  def response_params
    params.require(:response).permit(:response_message)
  end
end
