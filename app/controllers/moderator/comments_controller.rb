class Moderator::CommentsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @subblog = Subblog.find(params[:subblog_id])
    @comment = Comment.find(params[:id])
    if current_user != @subblog.user
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def update
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.find(params[:id])
    if current_user == @subblog.user
      @comment.update_attributes(comment_params)
      redirect_to moderator_subblog_blog_path(@subblog, @blog)
    end
  end

  def destroy
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.find(params[:id])
    if @subblog.user == current_user
      @comment.destroy
      redirect_to moderator_subblog_blog_path(@subblog, @blog)
    end
  end

  def create
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    if @subblog.user == current_user
      @comment = @blog.comments.create(comment_params.merge(user: current_user))
      redirect_to moderator_subblog_blog_path(@subblog, @blog)
    else
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:message)
  end

end
