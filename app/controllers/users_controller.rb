class UsersController < ApplicationController
  def show
    @articles = current_user.articles
  end

  def edit
  end


  def update
  end
end
