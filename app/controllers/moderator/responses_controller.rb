class Moderator::ResponsesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:destroy]
  before_action :authenticate_user!

  def destroy #needs test
    response = Response.find_by_id(params[:id])
    response.destroy if response
  end

end
