# frozen_string_literal: true

class MessagesController < ApplicationController
  include ImagesHelper
  before_action :set_twitter_client
  # before_action :new_message, only: [:show, :new]

  # 記事一覧
  def index
    if params[:user_id]
      # user_idのハッシュがあった時
      @user = User.find(params[:user_id])
      @user = User.find_by(monofy_id: params[:user_monofy_id])
      @messages = @user.messages.order(created_at: :desc)
    else
      @user = User.find_by(monofy_id: params[:user_monofy_id])
      # @messages = Message.all
      @message = Message.new
      @messages = @user.messages.order(created_at: :desc)
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

  # # 新規登録フォーム
  def new
    @user = User.find_by(monofy_id: params[:user_monofy_id])
    @message = Message.new
  end
  #
  # # 編集
  def edit
    @user = User.find_by(monofy_id: params[:user_monofy_id])
    @message = current_user.messages.find_by(url_token: params[:url_token])
  end

  # def new
  # end
  #
  # def edit
  # end

  def create
    @message = Message.new(message_params)
    # @message.author = User.where(:id => params[:user_id]).first
    @message.author = User.find_by(monofy_id: params[:user_monofy_id])

    # ipを保存
    @message.customer_ip = request.remote_ip

    # ハッシュを保存
    @message.url_token = SecureRandom.hex(10)

    if Message.last.present?
      next_id = Message.last.id + 1
    else
      next_id = 1
    end
    make_picture(next_id)

    # ImagesHelper.build(@message.message_text).tempfile.open.read
    # ImagesHelper.write(@message.message_text)

    if @message.save
      redirect_to controller: :messages, action: :index
    else
      render 'new'
    end
  end

  # ⑤createアクションを修正
  # def create
  #   # ⑤-1 @postに入力したcontent、kindが入っています。（id、pictureはまだ入っていません）
  #   @post = Post.new(post_params)
  #   # ⑤-2 idとして採番予定の数字を作成（現在作成しているidの次、存在しない場合は1を採番）
  #   if Post.last.present?
  #     next_id = Post.last.id + 1
  #   else
  #     next_id = 1
  #   end
  #   # ⑤-3 画像の生成メソッド呼び出し（画像のファイル名にidを使うため、引数として渡す）
  #   make_picture(next_id)
  #   if @post.save
  #     # ⑤-4 確認画面へリダイレクト
  #     redirect_to confirm_path(@post)
  #   else
  #     render :new
  #   end
  # end

  def update
    @message = current_user.messages.find_by(url_token: params[:url_token])
    @message.assign_attributes(message_params)

    if @message.save
      # flagが立った時、ツイートする
      @twitter.update("#{@message.answer_text}\r#{@message.music_url}") if @message.twitter_flag
      redirect_to controller: :messages, action: :show
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

  def set_post
    @message = Message.find(params[:id])
  end

  # ⑧メソッド追加
  # def new_message
  #   @message = Message.new
  # end

  def message_params
    params.require(:message).permit(:monofy_id, :url_token, :customer_ip, :message_text, :message_image, :answer_text, :music_url, :status, :twitter_flag)
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

  # ⑨メソッド追加（画像生成）
  def make_picture(id)
    sentense = ""
    # ⑨-1 改行を消去
    content = @message.message_text.gsub(/\r\n|\r|\n/," ")

    # ⑨-2 contentの文字数に応じて条件分岐
    if content.length <= 28 then
      # ⑨-3 28文字以下の場合は7文字毎に改行
      n = (content.length / 7).floor + 1
      n.times do |i|
        s_num = i * 7
        f_num = s_num + 6
        range =  Range.new(s_num,f_num)
        sentense += content.slice(range)
        sentense += "\n" if n != i+1
      end
      # ⑨-4 文字サイズの指定
      pointsize = 90
    elsif content.length <= 50 then
      n = (content.length / 10).floor + 1
      n.times do |i|
        s_num = i * 10
        f_num = s_num + 9
        range =  Range.new(s_num,f_num)
        sentense += content.slice(range)
        sentense += "\n" if n != i+1
      end
      pointsize = 60
    else
      n = (content.length / 15).floor + 1
      n.times do |i|
        s_num = i * 15
        f_num = s_num + 14
        range =  Range.new(s_num,f_num)
        sentense += content.slice(range)
        sentense += "\n" if n != i+1
      end
      pointsize = 45
    end

    # ⑨-5 文字色の指定
    color = "black"
    # ⑨-6 文字を入れる場所の調整（0,0を変えると文字の位置が変わります）
    draw = "text 0,0 '#{sentense}'"
    # ⑨-7 フォントの指定
    font = "./app/assets/fonts/geneinugothic-eb.ttf"
    # ⑨-8 ↑これらの項目も文字サイズのように背景画像や文字数によって変えることができます
    # ⑨-9 選択された背景画像の設定
    # case @post.kind
    # when "black" then
    #   base = "./app/assets/images/bg_image.png"
    #   # ⑨-10 今回は選択されていない場合は"red"となるようにしている
    # else
    #   base = "app/assets/images/red.jpg"
    # end
    base = "./app/assets/images/bg_image.png"
    # ⑨-11 minimagickを使って選択した画像を開き、作成した文字を指定した条件通りに挿入している
    image = MiniMagick::Image.open(base)
    image.combine_options do |i|
      i.font font
      i.fill color
      i.gravity 'center'
      i.pointsize pointsize
      i.draw draw
    end
    # ⑨-12 保存先のストレージの指定。Amazon S3を指定する。
    storage = Fog::Storage.new(
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION']
    )
    # ⑨-13 開発環境or本番環境でS3のバケット（フォルダのようなもの）を分ける
    case Rails.env
    when 'production'
      # ⑨-14 バケットの指定・URLの設定
      bucket = storage.directories.get(ENV['AWS_S3_BUCKET'])
      # ⑨-15 保存するディレクトリ、ファイル名の指定（ファイル名は投稿id.pngとしています）
      image_name = SecureRandom.hex(10)
      png_path = 'uploads/entry/' + image_name + '.png'
      image_uri = image.path
      file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
      @message.message_image = 'https://s3-ap-northeast-1.amazonaws.com/' + ENV['AWS_S3_BUCKET'] + "/" + png_path
    when 'development'
      bucket = storage.directories.get(ENV['AWS_S3_BUCKET'])
      image_name = SecureRandom.hex(10)
      png_path = 'uploads/entry/' + image_name + '.png'
      image_uri = image.path
      file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
      @message.message_image = 'https://s3-ap-northeast-1.amazonaws.com/'+ ENV['AWS_S3_BUCKET'] + "/" + png_path
    end
  end
end