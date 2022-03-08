class UsersController < ApplicationController
  def show
    @article = current_user.articles
  end

  def edit
  end


  def update
  end
end
