class RelationshipsController < ApplicationController
  # フォローする時
  def create
    current_user.follow(params[:user_id])

    # 通知機能
    @user = User.find(params[:user_id])
    @user.create_notification_follow!(current_user)
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  # フォロー外す時
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  # フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings.with_attached_image.includes([:image_attachment]).page(params[:page]).per(6)
  end

  # フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers.with_attached_image.includes([:image_attachment]).page(params[:page]).per(6)
  end
end
