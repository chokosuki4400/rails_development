# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :message_text, presence: true
  validates :url_token, presence: true, uniqueness: true

  # 公開記事のみ
  scope :common, -> { where(status: 0) }
  # 下書き以外（公開・会員限定）
  scope :published, -> { where('status <> ?', 'draft') }
  # 下書き以外と、自分が書いた記事全部
  scope :full, ->(user) {
    where('user_id = ? OR status <> ?', user.id, 'draft')
  }
  # ログインしていればfull、していなければcommon
  scope :readable_for, ->(user) { user ? full(user) : common }

  def to_param
    url_token
  end
end
