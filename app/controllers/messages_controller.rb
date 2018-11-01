class MessagesController < ApplicationController
  before_action :set_twitter_client

  # 記事一覧
  def index
    if params[:tag]
      # tagのハッシュがあった時
      # tagged_withでタグ「:tag」でタグごとにフィルター
      @messages = Message.tagged_with(params[:tag])
    elsif params[:user_id]
      # user_idのハッシュがあった時
      @user = User.find(params[:user_id])
      @messages = @user.messages
    else
      @user = User.where(:id => params[:user_id]).first
      @messages = Message.all
    end
    # @messages = @messages.readable_for(current_user)
    # .order(posted_at: :desc).paginate(page: params[:page], per_page: 20)
  end

  # 記事の詳細
  def show
    # @message = Message.find(params[:id])
    @user = User.where(:id => params[:user_id]).first
    @message = Message.readable_for(@user).find(params[:id])
  end

  # 新規登録フォーム
  def new
    @user = User.find(params[:user_id])
    @message = Message.new
  end

  # 編集
  def edit
    @user = User.find(params[:user_id])
    @message = current_user.messages.find(params[:id])
  end

  def create
    @message = Message.new(message_params)
    @message.author = User.where(:id => params[:user_id]).first
    # if user_signed_in?
    #   # ユーザーがサインイン済かどうかを判定する
    #   @message.author = current_user
    # else
    #   @message.author = User.where(:id => params[:user_id]).first
    # end

    # ipを保存
    @message.customer_ip = request.remote_ip

    if @message.save
      redirect_to controller: :messages, action: :index
    else
      render "new"
    end
  end

  def update
    @message = current_user.messages.find(params[:id])
    @message.assign_attributes(message_params)
    if @message.save
      @twitter.update("#{@message.answer_text}\r#{@message.music_url}")
      redirect_to controller: :messages, action: :index
    else
      render "edit"
    end
  end

  def destroy
    @message = current_user.messages.find(params[:id])
    @message.destroy
    redirect_to :messages, notice: "記事を削除しました。"
  end

  private

  def message_params
    params.require(:message).permit(:message_text, :answer_text, :music_url, :status, :twitter_flag)
  end

  def set_twitter_client
    @user = User.where(:id => params[:user_id]).first
    @twitter = Twitter::REST::Client.new do |config|
      config.consumer_key        = @user.consumer_key
      config.consumer_secret     = @user.consumer_secret
      config.access_token        = @user.access_token
      config.access_token_secret = @user.access_token_secret
    end
  end

end
