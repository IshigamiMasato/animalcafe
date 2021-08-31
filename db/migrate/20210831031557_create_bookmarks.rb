class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.integer :user_id
      t.integer :shop_id

      t.timestamps
    end
    add_index :bookmarks, :user_id
    add_index :bookmarks, :shop_id
    add_index :bookmarks, [:user_id, :shop_id], unique: true
  end
end
