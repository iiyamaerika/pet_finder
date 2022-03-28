class ChatsController < ApplicationController
  def index
    # 相互フォローのみDM可能
    # 以前やりとりしたことのあるユーザーを一覧で表示する
    room_ids = UserRoom.where(user_id: current_user.id).pluck(:room_id) #ログイン中のユーザーが持っているroom_idを探す
    #探してきたroom_idを持っているユーザーの中で、ログイン中ユーザーじゃない方のチャット相手のidを持ってくる
    chat_user_ids = UserRoom.where(room_id: room_ids).where.not(user_id: current_user.id).pluck(:user_id)
    @users = User.where(id: chat_user_ids)
  end

  def show
    @user = User.find(params[:id])
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    if user_rooms.nil?
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    else
      @room = user_rooms.room
    end

    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    render :validater unless @chat.save

    user_id = UserRoom.where(room_id: chat_params[:room_id]).where.not(user: current_user).first.user_id
    @user = User.find(user_id)
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    if user_rooms.present?
      # 新規作成された@chatに紐づくroomを@roomに格納する
      @room = @chat.room
      @room.create_notification_dm!(current_user, @chat.id, @user.id)
    end
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
