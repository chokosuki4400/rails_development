class AddUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notification_allowed, :boolean, default: false, null: false
  end
end
