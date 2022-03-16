class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def show
    favorites = Favorite.where(user_id: current_user.id).pluck(:article_id)
    @favorite_articles = Kaminari.paginate_array(Article.with_attached_image.order(created_at: :desc).find(favorites)).page(params[:page]).per(5)
  end

  def create
    @article = Article.find(params[:article_id])
    favorite = @article.favorites.new(user_id: current_user.id)
    favorite.save

    @article.create_notification_favorite!(current_user)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end

  end

  def destroy
    @article = Article.find(params[:article_id])
    favorite = @article.favorites.find_by(user_id: current_user.id)
    favorite.destroy
  end
end
