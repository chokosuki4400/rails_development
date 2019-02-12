# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index show new]
  $description = "なんでだッ!?は、匿名の人からツッコミの一言をもらって、あなたがボケを考えて答えることのできるサービスです。ボケとツッコミのワンセットを完成させてみんなで楽しんで下さい。"

  def index
    # @users = User.all
    flash[:notice] = 'ログイン済ユーザーのみ記事の詳細を確認できます' unless user_signed_in?
    @user = current_user
    # @messages = Message.all
    @messages = @user.messages.where(status: false).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def show
    # @user = User.find(params[:id])
    @user = User.find_by(nandeda_id: params[:nandeda_id])
    @messages = @user.messages.order(created_at: :desc)
  end
end
