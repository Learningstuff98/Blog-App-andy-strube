class Moderator::ResponsesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:destroy]
  before_action :authenticate_user!

  def new
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    @response = Response.new
    if current_user != @subblog.user
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

end
