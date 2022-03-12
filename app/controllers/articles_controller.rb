class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :ensure_correct_user, only: [:update, :edit, :destroy]

  def index
    @articles = Article.all
    @search = Article.ransack(params[:q]) #検索機能で使用
    @search_articles = @search.result(distinct: true) #検索結果表示で使用
  end

  def show
    @article = Article.find(params[:id])
    @post_comment = PostComment.new
  end

  def new
    @article = Article.new
  end

  def create
    article = Article.new(article_params)
    article.user_id = current_user.id
    if article.save
      redirect_to article_path(article.id)
    else
      render :new
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to article_path(@article),
      notice: "権限がありません。"
    else
      render "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.delete
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:status, :image, :title, :date, :prefecture, :place, :animal_type, :animal_sex, :animal_age, :animal_breed, :introduction)
  end

  def ensure_correct_user
    @article = Article.find(params[:id])
    unless @article.user == current_user
      redirect_to articles_path
    end
  end

end
