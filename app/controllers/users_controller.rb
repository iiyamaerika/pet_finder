class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :shelter]
  before_action :ensure_guest_user, only: [:edit]

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

  private
  
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "ゲストユーザー"
      redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end  

end
