class Article < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :notifications, dependent: :destroy # 通知機能

  enum status: { lost: 0, protection: 1, foster_homes: 2, solved: 3 }
  enum animal_sex: { male: 0, female: 1, unknown: 2 }

  validates :status, presence: true
  validates :title, presence: true
  validates :date, presence: true
  validates :prefecture, presence: true
  validates :place, presence: true
  validates :animal_type, presence: true
  validates :animal_sex, presence: true
  validates :animal_age, presence: true
  validates :introduction, presence: true
  # 画像なしでも投稿できるようにimageに対するバリデーションは無し

  # 投稿画像がない場合は"noimage.png"を表示させる
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/noimage.png')
      image.attach(io: File.open(file_path), filename: 'noimage.png', content_type: 'image/png')
    end
    image.variant(resize_to_fill: [width, height]).processed
  end

  # いいね機能
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 通知機能(いいね)
  def create_notification_favorite!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and article_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        article_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  # 通知機能(コメント)
  def create_notification_comment!(current_user, post_comment_id)
    # 同じ投稿にコメントしているユーザーに通知を送る。（current_userと投稿ユーザーのぞく）
    temp_ids = PostComment.where(article_id: id).where.not("user_id=? or user_id=?", current_user.id, user_id).select(:user_id).distinct
    # 取得したユーザー達へ通知を作成。（user_idのみ繰り返し取得）
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, post_comment_id, temp_id['user_id'])
    end
    # 投稿者へ通知を作成
    save_notification_comment!(current_user, post_comment_id, user_id)
  end

  def save_notification_comment!(current_user, post_comment_id, visited_id)
    notification = current_user.active_notifications.new(
      article_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
