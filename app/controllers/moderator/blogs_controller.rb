class Moderator::BlogsController < ApplicationController
  before_action :authenticate_user!

  def new
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.new
    if current_user != @subblog.user
      render plain: 'Unauthorized', status: :unauthorized 
    end
  end

  def create
    @subblog = Subblog.find(params[:subblog_id])
    if current_user == @subblog.user
      @blog = @subblog.blogs.create(blog_params.merge(user: current_user))
      if @blog.valid?
        @lock = @blog.locks.create()
        redirect_to moderator_subblog_blog_path(@subblog, @blog)
      else
        render :new, status: :unprocessable_entity
      end
    else
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

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
    else
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def show
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:id])
    @lock = @blog.locks.last
    @comment = Comment.new
    if current_user != @subblog.user
      render plain: 'Unauthorized', status: :unauthorized
    end
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
