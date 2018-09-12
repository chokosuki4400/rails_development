class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_one :userinfo, dependent: :destroy, inverse_of: :user
  has_many :questions, dependent: :destroy
  mount_uploader :image, ImageUploader

  # before_create :build_userinfo
  accepts_nested_attributes_for :userinfo, update_only: true
  # accepts_nested_attributes_for :question, update_only: true
end
