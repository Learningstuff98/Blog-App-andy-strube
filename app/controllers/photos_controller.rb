class PhotosController < ApplicationController
  before_action :authenticate_user!

  def create
    @subblog = Subblog.find(params[:subblog_id])
    @blog = Blog.find(params[:blog_id])
    if @blog.user == current_user
      @blog.photos.create(photo_params)
      redirect_to subblog_blog_path(@subblog, @blog)
    else
      render plain: 'Unauthorized', status: :unauthorized
    end
  end
    
  private
  
  def photo_params
    params.require(:photo).permit(:caption, :picture)
  end

end
