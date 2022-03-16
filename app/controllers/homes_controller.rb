class HomesController < ApplicationController
  
  # 新着記事として最初の５件表示
  def top
    @articles = Article.with_attached_image.includes([:image_attachment]).order(created_at: :desc).first(5)
  end
  
end
