class Moderator::SubblogsController < ApplicationController
  before_action :authenticate_user!

  def new
    @subblog = Subblog.new
  end

  def create
    @subblog = current_user.subblogs.create(subblog_params)
    if @subblog.valid?
      redirect_to subblog_path(@subblog)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @subblog = Subblog.find(params[:id])
    if current_user != @subblog.user
      render plain: 'Unauthorized', status: :unauthorized
    end
    @blogs = @subblog.blogs.order("created_at DESC").page(params[:page]).per_page(2)
  end

  private

  def subblog_params
    params.require(:subblog).permit(:name, :description)
  end

end
