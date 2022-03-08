class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :articles, dependent: :destroy
  
  # いいね・コメント機能
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  
  # フォロー・フォロワー機能
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  #DM機能
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  
  #バリデーション
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :name_kana, length: { minimum: 2, maximum: 20 }, uniqueness: true

  #ユーザー情報変更の際に現在のパスワードはパラメーター内で不要となり、
  #かつパスワードとパスワードの確認を空とした場合、パスワードの更新はなされなくなる
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

end
