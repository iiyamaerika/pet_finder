class ArticlesController < ApplicationController
  
  def index
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(articke_params)
    if @article.save
      redirect_to user_path(current_user)
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
    params.require(:article).permit(:status, :image, :title, :date, :prefecture, :place, :animal_type, :animal_age, :animal_sex, :introduction).merge(user_id: current_user.id)
  end
  
end
