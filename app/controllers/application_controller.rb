# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # 未ログイン時、ログインページへリダイレクト
  # before_action :authenticate_user!
  # before_filter :authenticate_person!

  # CSRF保護をオンにする以下の1行を有効にします。
  protect_from_forgery with: :exception
  # ログイン済ユーザーのみにアクセスを許可する
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    users_path
  end

  private

  def login_required
    raise Forbidden unless current_user
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password password_confirmation current_password name monofy_id profile image image_cache])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[email password password_confirmation current_password name monofy_id profile image image_cache])
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:profile])
  end
end
