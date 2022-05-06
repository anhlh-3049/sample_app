class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".flash_create_info"
      redirect_to root_path
    else
      flash.now[:danger] = t ".flash_create_danger"
      render :new
    end
  end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t(".error")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t ".flash_update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  private
  def find_user
    @user = User.find_by email: params[:email]
    redirect_to root_path unless @user
  end

  def valid_user
    return if @user&.activated&.authenticated?(:reset, params[:id])

    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".flash_danger"
    redirect_to new_password_reset_path
  end
end
