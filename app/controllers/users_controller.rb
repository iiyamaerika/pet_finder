class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update]

  def index
    @shelter_users = User.shelter.with_attached_image.includes([:image_attachment]).page(params[:page]).per(6)
  end

  def show
    @articles = current_user.articles.with_attached_image.order(created_at: :desc)
    @user = User.find(params[:id])
  end

  def shelter
    @user = User.find(params[:user_id])
    @articles = @user.articles.with_attached_image.order(created_at: :desc).page(params[:page]).per(6)
  end

  def unsubscribe
  end

  def withdraw
    user = current_user
    user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
