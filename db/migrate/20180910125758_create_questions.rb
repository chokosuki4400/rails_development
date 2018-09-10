class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.references :user, null: false
      t.text :body
      t.boolean :status, default: false, null: false

      t.timestamps
    end
  end
end
