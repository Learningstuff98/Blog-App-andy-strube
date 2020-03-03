class Moderator::ResponsesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:destroy]
  before_action :authenticate_user!

  def new
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.find(params[:comment_id])
    @response = Response.new
    if current_user != @subblog.user
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def create
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.find(params[:comment_id])
    if current_user == @subblog.user
      @response = @comment.responses.create(response_params.merge(user: current_user))
      @response.update_attribute(:username, @response.user.username)
      redirect_to moderator_subblog_blog_path(@subblog, @blog)
    else
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def destroy
    subblog = Subblog.find(params[:subblog_id])
    if current_user == subblog.user
      response = Response.find_by_id(params[:id])
      response.destroy
    end
  end

  private

  def response_params
    params.require(:response).permit(:response_message)
  end

end
