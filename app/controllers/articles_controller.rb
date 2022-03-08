class ArticlesController < ApplicationController

  def index
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    article = Article.new(article_params)
    if article.save
      redirect_to article_path(article.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def article_params
    params.require(:article).permit(:status, :image, :title, :date, :prefecture, :place, :animal_type, :animal_sex, :animal_age, :animal_breed, :introduction).merge(user_id: current_user.id)
  end

end
