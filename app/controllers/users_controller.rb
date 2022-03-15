class UsersController < ApplicationController

  def index
    @shelter_users = User.shelter
  end

  def show
    @articles = current_user.articles.with_attached_image.order(created_at: :desc)
    @user = User.find(params[:id])
  end

  def shelter
    @user = User.find(params[:user_id])
    @articles = @user.articles.with_attached_image.order(created_at: :desc)
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


end
