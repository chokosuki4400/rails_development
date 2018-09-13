class Message < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"

  scope :common, -> { where(status: 0) }
  scope :published, -> { where("status <> ?", "draft") }
  scope :full, ->(user) {
    where("user_id = ? OR status <> ?", user.id, "draft")
  }
  scope :readable_for, ->(user) { user ? full(user) : common }

end
