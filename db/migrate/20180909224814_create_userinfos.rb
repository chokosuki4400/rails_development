class CreateUserinfos < ActiveRecord::Migration[5.2]
  def change
    create_table :userinfos do |t|
      t.references :user, null: false
      t.string :name
      t.string :site_id
      t.text :profile

      t.timestamps
    end
  end
end
