class MessagesController < ApplicationController

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
      @messages = Message.all
    end
    @messages = @messages.readable_for(current_user)
    # .order(posted_at: :desc).paginate(page: params[:page], per_page: 20)
  end

  # 記事の詳細
  def show
    @message = Message.find(params[:id])
    # @message = Message.readable_for(current_user).find(params[:id])
  end

  # 新規登録フォーム
  def new
    @message = Message.new
  end

  # 編集
  def edit
    @message = current_user.messages.find(params[:id])
  end

  def create
    @message = Message.new(message_params)
    @message.author = current_user
    if @message.save
      redirect_to @message, notice: "記事を作成しました。"
    else
      render "new"
    end
  end

  def update
    @message = current_user.messages.find(params[:id])
    @message.assign_attributes(message_params)
    if @message.save
      redirect_to @message, notice: "記事を更新しました。"
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
    params.require(:message).permit(:message_text, :answer_text, :status)
  end

end
