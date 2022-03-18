class ChatsController < ApplicationController
  
  def index
    # 相互フォローのみDM可能
    @users = current_user.followings.with_attached_image.includes([:image_attachment]) & current_user.followers.with_attached_image.includes([:image_attachment])
  end

  def show
    @user = User.find(params[:id])
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    
    unless user_rooms.nil?
      @room = user_rooms.room
    else
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    render :validater unless @chat.save
      
    
    #通知機能
    @user = User.find(params[:id])
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    
    @room = user_rooms.room
    @room_member = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    notification = current_user.passive_notifications.new(
        room_id: @room.id,
        message_id: @chat.id,
        visited_id: @room_member.user_id,  #DM相手
        visitor_id: current_user.id,
        action: 'dm'
        )
    
    if notification.visitor_id == notification.visited_id
      notification.checked = false
    else
      @chat.save
      notification.checked = true
    end
    
    # if UserRoom.where(user_id: current_user.id, room_id: params[:chat][:room_id]).present?
    #   @new_chat = Chat.create(params.require(:chat).permit(:user_id, :message, :room_id).merge(user_id: current_user.id))
    #   @room = @new_chat.room
    #   @room.create_notification_dm!(current_user, @new_chat.id)
    #   rredirect_to request.referer
    # else
    #   redirect_back(fallback_location: root_path)
    # end
    
  end
  
  private
  
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
  
  def redirect_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to articles_path
    end
  end
end