class Moderator::BlogsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :destroy]
  
  def show
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:id])
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
