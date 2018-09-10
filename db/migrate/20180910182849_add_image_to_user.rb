class AddImageToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :name, :string
    add_column :users, :site_id, :string
    add_column :users, :profile, :text
    add_column :users, :image, :string
  end
end
