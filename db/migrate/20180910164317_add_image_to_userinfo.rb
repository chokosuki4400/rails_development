class AddImageToUserinfo < ActiveRecord::Migration[5.2]
  def change
    add_column :userinfos, :image, :string
  end
end
