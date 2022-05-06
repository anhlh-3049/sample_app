class UsersController < ApplicationController
  before_action :find_user, except: :index
  before_action :logged_in_user, except: %i(new create show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.all)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".flash_info"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".flash_update"
      redirect_to @user
    else
      flash[:error] = t ".flash_error_update"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".flash_destroy"
    else
      flash[:danger] = t ".flash_danger_des"
    end
    redirect_to @users
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
    redirect_to root_path unless @user
  end

  def correct_user
    redirect_to root_path unless current_user? @user
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".flash_danger_login"
    redirect_to login_path
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
