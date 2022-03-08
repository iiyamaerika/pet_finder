class ArticlesController < ApplicationController

  def index
    @articles = Article.all
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
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to article_path(@article), notice: "You have updated book successfully."
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
    params.require(:article).permit(:status, :image, :title, :date, :prefecture, :place, :animal_type, :animal_sex, :animal_age, :animal_breed, :introduction).merge(user_id: current_user.id)
  end

end
