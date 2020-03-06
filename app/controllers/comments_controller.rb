class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :edit, :update]
  
  def create
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = @blog.comments.create(comment_params.merge(user: current_user))
    redirect_to subblog_blog_path(@subblog, @blog)
  end

  def destroy
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to subblog_blog_path(@subblog, @blog)
    else
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    if current_user != @comment.user
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def update
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.find(params[:id])
    if current_user == @comment.user
      @comment.update_attributes(comment_params)
      redirect_to subblog_blog_path(@subblog, @blog)
    end
  end

  def show
    comment = Comment.find(params[:id])
    comment.responses.each do |response|
      response.update_attribute(:time_since, response.time_since_post)
    end
    render json: comment.responses.as_json()
  end

  private

  def comment_params
    params.require(:comment).permit(:message)
  end

end
