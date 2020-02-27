class Moderator::BlogsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:id])
    if current_user != @subblog.user
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def show
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:id])
    @comment = Comment.new
  end

  def destroy
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:id])
    if @subblog.user == current_user
      @blog.destroy
      redirect_to moderator_subblog_path(@subblog)
    end
  end

end
