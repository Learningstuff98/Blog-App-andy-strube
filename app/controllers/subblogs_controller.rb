class SubblogsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @subblogs = Subblog.order("name").page(params[:page]).per_page(2)
    @search = params["search"]
    if @search.present?
      @name = @search["name"]
      @subblogs = Subblog.where("name ILIKE ?", "%#{@name}%")
      @subblogs = @subblogs.order("name").page(params[:page]).per_page(2)
    end
  end

  def new
    @subblog = Subblog.new
  end

  def create
    @subblog = current_user.subblogs.create(subblog_params)
    if @subblog.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @subblog = Subblog.find(params[:id])
    @blogs = @subblog.blogs.order("created_at DESC").page(params[:page]).per_page(2)
  end

  private

  def subblog_params
    params.require(:subblog).permit(:name, :description)
  end

end
