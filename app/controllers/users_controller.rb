class UsersController < ApplicationController

  def index
    @shelter_users = User.shelter
  end

  def show
    @articles = current_user.articles.order(created_at: :desc)
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

end
