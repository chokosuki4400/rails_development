class AddImageToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :consumer_key, :string
    add_column :users, :consumer_secret, :string
    add_column :users, :access_token, :string
    add_column :users, :access_token_secret, :string
    add_column :users, :name, :string
    add_column :users, :nickname, :string
    add_column :users, :site_id, :string
    add_column :users, :profile, :text
    add_column :users, :image, :string
  end
end
