class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.references :question, null: false
      t.text :body
      t.boolean :status, default: false, null: false

      t.timestamps
    end
  end
end
