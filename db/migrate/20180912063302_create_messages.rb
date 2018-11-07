# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :user, null: false
      t.string :url_token, null: false, unique: true
      t.string :customer_ip
      t.text :message_text, null: false
      t.text :answer_text
      t.text :music_url
      t.boolean :twitter_flag, null: false, default: 0
      t.boolean :status, null: false, default: 0
      t.timestamps
    end
  end
end
