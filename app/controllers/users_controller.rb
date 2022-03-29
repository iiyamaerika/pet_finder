class UsersController < ApplicationController

  def index
    @shelter_users = User.shelter.with_attached_image.includes([:image_attachment]).page(params[:page]).per(6)
  end

  def show
    @user = User.find(params[:id])
    @articles = @user.articles.with_attached_image.order(created_at: :desc).page(params[:page]).per(6)
  end

  # 他のユーザーが編集しようとするとトップページに遷移させる
  def edit
    redirect_to root_path
  end
  
  def update
    redirect_to root_path
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


end
