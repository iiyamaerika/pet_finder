class Article < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites_users, through: :favorites, source: :user


  enum status: { lost: 0, protection: 1, foster_homes: 2, solved: 3 }
  enum animal_sex: { male: 0, female: 1, unknown: 2 }

end
