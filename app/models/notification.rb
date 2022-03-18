class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }  #通知は新しい順に表示
  belongs_to :article, optional: true  #optional: trueで外部キーがnilであってもDBに保存↓
  belongs_to :post_comment, optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true
  
  ACTION_VALUES = ["favorite", "comment","follow"]
  
  validates :visitor_id, presence: true
  validates :visited_id, presence: true
  validates :action,  presence: true, inclusion: {in:ACTION_VALUES}  #保存できる値をACTION_VALUESに制限
  validates :checked, inclusion: {in: [true,false]}  #保存できる値をtrue,falseに制限
end
