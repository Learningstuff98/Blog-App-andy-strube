class BlogsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def new
    @blog = Blog.new
  end

  def create
    @subblog = Subblog.find(params[:subblog_id])
    @blog = @subblog.blogs.create(blog_params.merge(user: current_user))
    if @blog.valid?
      @lock = @blog.locks.create()
      redirect_to subblog_blog_path(@subblog, @blog)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:id])
    if current_user != @blog.user
      render plain: 'Unauthorized', status: :unauthorized
    end
    lock = @blog.locks.last
    render plain: 'Unauthorized', status: :unauthorized if lock.is_locked
  end

  def update
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:id])
    lock = @blog.locks.last
    if @blog.user == current_user && !lock.is_locked
      @blog.update_attributes(blog_params)
      redirect_to subblog_blog_path(@subblog, @blog)
    else
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def destroy
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:id])
    if @blog.user == current_user
      @blog.destroy
      redirect_to subblog_path(@subblog)
    end
  end

  def show
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:id])
    @lock = @blog.locks.last
    @comment = Comment.new
  end

  private

  def blog_params
    params.require(:blog).permit(:content, :title)
  end

end
