class Article < ApplicationRecord
  
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites_users, through: :favorites, source: :user
  
end
