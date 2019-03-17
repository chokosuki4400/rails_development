class ChangeDatatypeNotificationAllowedOfUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :notification_allowed, :boolean, default: true, null: false
  end
end
