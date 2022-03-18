class Room < ApplicationRecord
  
  has_many :chats, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  
  def create_notification_dm!(current_user, chat_id)
    @all_room_member = UserRoom.where(room_id: id).where.not(user_id: current_user.id)
    @first_room_member = @all_room_member.find_by(room_id: id)
    notification = current_user.active_notifications.build(
      room_id: id,
      chat_id: chat_id,
      visited_id: @first_room_member.user_id,
      action: 'dm'
      
      
      
    )

    notification.save if notification.valid?
  end
end
