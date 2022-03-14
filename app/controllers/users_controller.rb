class UsersController < ApplicationController

  def index
    @shelter_users = User.shelter
  end

  def show
    @articles = current_user.articles.with_attached_image.order(created_at: :desc)
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
      if @user != current_user
        redirect_to user_path(current_user)
      else
        render "edit"
      end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "会員情報を変更しました。"
    else
      render "edit"
    end
  end

  def shelter
    @shelter_users = User.shelter
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
