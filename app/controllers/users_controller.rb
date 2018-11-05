class UsersController < ApplicationController
	before_action :authenticate_user!, only: [:index,:show,:new]

  def index
  	# @users = User.all
  	flash[:notice] = "ログイン済ユーザーのみ記事の詳細を確認できます" unless user_signed_in?
  end

  def show
  	# @user = User.find(params[:id])
  	@user = User.find_by(monofy_id: params[:monofy_id])
  	@messages = @user.messages
  end
end
