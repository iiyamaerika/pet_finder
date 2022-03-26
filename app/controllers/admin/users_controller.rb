class Admin::UsersController < ApplicationController
  before_action :admin_user
  
  def index
    @users = User.all.order(created_at: :desc).with_attached_image.includes([:image_attachment]).page(params[:page]).per(6)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to admin_root_path
  end

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def user_params
    #admin=trueに書き換えられないようにadminをpermitに入れない
    params.require(:user).permit(:category, :name, :name_kana, :nickname, :telephone_number, :address, :is_deleted)
  end


end
