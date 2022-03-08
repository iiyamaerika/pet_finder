class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def after_sign_in_path_for(resource)
    about_path  #ログイン後はuserの詳細画面ページへ遷移予定
  end
  
  def after_sign_out_path_for(resource)
    root_path  #ログアウト後はhomes/topページへ
  end
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :name_kana, :telephone_number, :address])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :name_kana, :telephone_number, :address])
  end
  
  
end
