class ResponsesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:destroy]
  before_action :authenticate_user!

  def edit
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.find(params[:comment_id])
    @response = Response.find(params[:id])
    @lock = @blog.locks.last
    if current_user != @response.user || @lock.is_locked
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def update
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @response = Response.find(params[:id])
    @lock = @blog.locks.last
    if !@lock.is_locked
      if current_user == @response.user
        @response.update_attributes(response_params)
        redirect_to subblog_blog_path(@subblog, @blog)
      end
    else
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def destroy
    response = Response.find(params[:id])
    if current_user == response.user
      response.destroy
    end
  end

  def show
    response = Response.find(params[:id])
    render json: response.as_json()
  end

  def new
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.find(params[:comment_id])
    @response = Response.new
    @lock = @blog.locks.last
    if @lock.is_locked
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def create
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.find(params[:comment_id])
    @lock = @blog.locks.last
    if !@lock.is_locked
      @response = @comment.responses.create(response_params.merge(user: current_user))
      if @response.valid?
        redirect_to subblog_blog_path(@subblog, @blog)
        @response.update_attribute(:username, @response.user.username)
      else
        render :new, status: :unprocessable_entity
      end
    else
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  private

  def response_params
    params.require(:response).permit(:response_message)
  end
end
