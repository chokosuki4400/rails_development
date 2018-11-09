# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_twitter_client

  # 記事一覧
  def index
    if params[:user_id]
      # user_idのハッシュがあった時
      @user = User.find(params[:user_id])
      @user = User.find_by(monofy_id: params[:user_monofy_id])
      @messages = @user.messages
    else
      @user = User.find_by(monofy_id: params[:user_monofy_id])
      # @messages = Message.all
      @message = Message.new
      @messages = @user.messages
    end
    # @messages = @messages.readable_for(current_user)
    # .order(posted_at: :desc).paginate(page: params[:page], per_page: 20)
  end

  # 記事の詳細
  def show
    # @message = Message.find(params[:id])
    # @user = User.where(:id => params[:user_id]).first
    @user = User.find_by(monofy_id: params[:user_monofy_id])
    # @message = Message.readable_for(@user).find(params[:id])
    @message = Message.find_by(url_token: params[:url_token])
  end

  # 新規登録フォーム
  def new
    @user = User.find_by(monofy_id: params[:user_monofy_id])
    @message = Message.new
  end

  # 編集
  def edit
    @user = User.find_by(monofy_id: params[:user_monofy_id])
    @message = current_user.messages.find_by(url_token: params[:url_token])
  end

  def create
    @message = Message.new(message_params)
    # @message.author = User.where(:id => params[:user_id]).first
    @message.author = User.find_by(monofy_id: params[:user_monofy_id])

    # ipを保存
    @message.customer_ip = request.remote_ip

    # ハッシュを保存
    @message.url_token = SecureRandom.hex(10)

    if @message.save
      redirect_to controller: :messages, action: :index
    else
      render 'new'
    end
  end

  def update
    @message = current_user.messages.find_by(url_token: params[:url_token])
    @message.assign_attributes(message_params)

    if @message.save
      # flagが立った時、ツイートする
      @twitter.update("#{@message.answer_text}\r#{@message.music_url}") if @message.twitter_flag
      redirect_to controller: :messages, action: :index
    else
      render 'edit'
    end
  end

  def destroy
    @message = current_user.messages.find_by(url_token: params[:url_token])
    @message.destroy
    redirect_to :messages, notice: '記事を削除しました。'
  end

  private

  def message_params
    params.require(:message).permit(:monofy_id, :url_token, :customer_ip, :message_text, :answer_text, :music_url, :status, :twitter_flag)
  end

  def set_twitter_client
    # @user = User.where(:id => params[:user_id]).first
    @user = User.find_by(monofy_id: params[:user_monofy_id])
    if @user.provider === 'twitter'
      @twitter = Twitter::REST::Client.new do |config|
        config.consumer_key        = @user.consumer_key
        config.consumer_secret     = @user.consumer_secret
        config.access_token        = @user.access_token
        config.access_token_secret = @user.access_token_secret
      end
    end
  end
end
