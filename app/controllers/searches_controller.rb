class SearchesController < ApplicationController
  
  def search
    @articles = Article.search(params[:search])
    @q = Article.ransack(params[:q])
  end
  
  
end
