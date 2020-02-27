class Moderator::BlogsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:id])
    if current_user != @subblog.user
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def update
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:id])
    if current_user == @subblog.user
      @blog.update_attributes(blog_params)
      redirect_to moderator_subblog_blog_path(@subblog, @blog)
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

  private

  def blog_params
    params.require(:blog).permit(:title, :content)
  end

end
