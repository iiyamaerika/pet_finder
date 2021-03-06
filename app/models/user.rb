class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles, dependent: :destroy
  has_one_attached :image

  # いいね・コメント機能
  has_many :favorites, dependent: :destroy
  has_many :favorite_articles, through: :favorites, source: :article
  has_many :post_comments, dependent: :destroy

  # 通知機能
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy # 自分からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy # 相手からの通知

  # フォロー・フォロワー機能
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # DM機能
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy

  # バリデーション
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :name_kana, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :address, presence: true
  validates :category, presence: true
  validates :telephone_number, length: { in: 6..11 }

  enum category: { private_user: 0, shelter: 1 }

  # ユーザー情報変更の際に現在のパスワードはパラメーター内で不要となり、
  # かつパスワードとパスワードの確認を空とした場合、パスワードの更新はなされなくなる
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  # 投稿画像がない場合は"noimage.png"を表示させる
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/noimage.png')
      image.attach(io: File.open(file_path), filename: 'noimage.png', content_type: 'image/png')
    end
    image.variant(resize_to_fill: [width, height]).processed
  end

  # is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && (is_deleted == false)
  end

  # フォローする時
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  # フォローを外す時
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  # フォローしているのか判定
  def following?(user)
    followings.include?(user)
  end

  # フォロー通知
  def create_notification_follow!(current_user)
    # すでに通知が作成されているか確認
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ", current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  # admin検索(カテゴリの指定なしの場合)
  def self.searches(search)
      User.where(['name LIKE ?', "%#{search}%"])
  end

  # admin検索(カテゴリの指定ありの場合)
  def self.looks(category,word)
    if category == "private_user"
      @user = User.where("name LIKE?", "%#{word}%").and(where(category: "private_user"))
    else
      @user = User.where("name LIKE?", "%#{word}%").and(where(category: "shelter"))
    end
  end
  
  def self.guest
    find_or_create_by!(name: 'ゲストユーザー', email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
      user.name_kana = "ゲストユーザー"
      user.nickname = "ゲストユーザー"
      user.telephone_number = "00000000000"
      user.address = "日本"
      user.category = "private_user"
    end
  end



end
