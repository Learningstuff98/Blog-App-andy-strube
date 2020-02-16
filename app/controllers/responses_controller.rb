class ResponsesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:destroy]
  before_action :authenticate_user!

  def show
    response = Response.find(params[:id])
    render json: response.as_json()
  end

  def destroy
    response = Response.find_by_id(params[:id])
    response.destroy if response
  end

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
