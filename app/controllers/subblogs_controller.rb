class SubblogsController < ApplicationController
  
  def index
    @subblogs = Subblog.order("name").page(params[:page]).per_page(2)
    @search = params["search"]
    if @search.present?
      @name = @search["name"]
      @subblogs = Subblog.where("name ILIKE ?", "%#{@name}%")
      @subblogs = @subblogs.order("name").page(params[:page]).per_page(2)
    end
  end

  def show
    @subblog = Subblog.find(params[:id])
    @blogs = @subblog.blogs.order("created_at DESC").page(params[:page]).per_page(2)
  end

end
