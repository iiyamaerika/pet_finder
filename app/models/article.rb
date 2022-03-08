class Article < ApplicationRecord

  belongs_to :user
  has_one_attached :image
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites_users, through: :favorites, source: :user


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


  def get_image(size)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/noimage.png')
      image.attach(io: File.open(file_path), filename: 'noimage.png', content_type: 'image/png')
    end
      image.variant(resize: size).processed
  end

end
