class Moderator::LocksController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def show
    lock = Lock.find(params[:id])
    render json: lock.as_json()
  end

  def update
    lock = Lock.find(params[:id])
    lock.update_attribute(:is_locked, !lock.is_locked)
  end

end
