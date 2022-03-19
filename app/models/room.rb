class Room < ApplicationRecord
  
  has_many :chats, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  
  def create_notification_dm!(current_user, chat_id, user_id)

    notification = current_user.active_notifications.build(
      #room_id: @room.id,
      chat_id: chat_id,
      visited_id: user_id,  #DM相手
      # visitor_id: current_user.id,
      action: 'dm'
    )

    notification.save if notification.valid?
  end
end
