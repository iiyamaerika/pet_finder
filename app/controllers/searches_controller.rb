class SearchesController < ApplicationController
  def search
    @q = Article.ransack(params[:q])
    @search_articles = @q.result(distinct: true).with_attached_image.includes([:image_attachment]).order(created_at: :desc).page(params[:page]).per(9)
    # 検索結果は最新順
  end
end
