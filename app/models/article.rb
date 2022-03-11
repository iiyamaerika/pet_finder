class Article < ApplicationRecord

  belongs_to :user
  has_one_attached :image
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy


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
  #画像なしでも投稿できるようにimageに対するバリデーションは無し

  #投稿画像がない場合は"noimage.png"を表示させる
  def get_image(size)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/noimage.png')
      image.attach(io: File.open(file_path), filename: 'noimage.png', content_type: 'image/png')
    end
      image.variant(resize: size).processed
  end
  
  #いいね機能
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  

end
