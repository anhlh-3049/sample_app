class SessionsController < ApplicationController
  before_action :find_by_email, only: :create

  def create
    if @user&.authenticate params[:session][:password]
      user_activated
    else
      flash.now[:danger] = t ".flash"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private
  def find_by_email
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash[:danger] = t ".flash_error"
    redirect_to root_path
  end
end
