class MicropostsController < ApplicationController
  before_action :correct_user, only: :destroy
  before_action :logged_in_user, only: %i(create destroy)

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t ".flash_save"
      redirect_to root_path
    else
      @feed_items = current_user.feed.page params[:page]
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".flash_destroy"
      redirect_to request.referer || root_path
    else
      flash[:danger] = t ".flash_danger_des"
      render "static_pages/home"
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost.nil?

    flash[:error] = t ".flash_error"
    redirect_to root_url
  end
end
