class Moderator::SubblogsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

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

  private

  def subblog_params
    params.require(:subblog).permit(:name, :description)
  end

end
