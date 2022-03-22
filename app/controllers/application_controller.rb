class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top, :index, :shelter, :about]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:category, :name, :name_kana, :nickname, :telephone_number, :address, :image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:category, :name, :name_kana, :nickname, :telephone_number, :address, :image])
  end

  def set_search
    @q = Article.ransack(params[:q])
    @search_articles = @q.result(distinct: true)
  end
end
