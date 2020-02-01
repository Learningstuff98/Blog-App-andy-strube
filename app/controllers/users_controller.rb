class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @blogs = @user.blogs.order("created_at DESC").page(params[:page]).per_page(2)
  end

end
