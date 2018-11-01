class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:twitter]
  has_one :userinfo, dependent: :destroy, inverse_of: :user
  has_many :messages, dependent: :destroy
  # mount_uploader :image, ImageUploader

  # before_create :build_userinfo
  accepts_nested_attributes_for :userinfo, update_only: true
  # accepts_nested_attributes_for :question, update_only: true

  def self.from_omniauth(auth)
    logger.debug('===========================')
    logger.debug(auth["info"]["image"])
    logger.debug(auth["info"]["description"])
    find_or_create_by(provider: auth["provider"], uid: auth["uid"]) do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.nickname = auth["info"]["nickname"]
      user.email = User.dummy_email(auth)
      user.access_token = auth["credentials"]["token"]
      user.access_token_secret = auth["credentials"]["secret"]
      user.image = auth["info"]["image"]
      user.profile = auth["info"]["description"]
    end
  end


  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"]) do |user|
        user.attributes = params
      end
    else
      super
    end
  end
  # Edit時、OmniAuthで認証したユーザーのパスワード入力免除するため、Deviseの実装をOverrideする。
  def update_with_password(params, *options)
    if encrypted_password.blank? # encrypted_password属性が空の場合
      update_attributes(params, *options) # パスワード入力なしにデータ更新
    else
      super
    end
  end

  private

  def self.dummy_email(auth)
    "#{auth["uid"]}-#{auth["provider"]}@example.com"
  end

  protected
  def confirmation_required?
    false
  end

  def password_required?
    super && provider.blank? # provider属性に値があればパスワード入力免除
  end

  def email_required?
    if provider.blank? #provider属性に値があれば、emailのvalidata_presenceを免除
      true
    else
      false
    end
  end
end

