class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :shop_id

      t.timestamps
    end
    add_index :likes, :user_id
    add_index :likes, :shop_id
    add_index :likes, [:user_id, :shop_id], unique: true
  end
end
