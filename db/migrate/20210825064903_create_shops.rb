class CreateShops < ActiveRecord::Migration[6.1]
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.time :started_at
      t.time :closed_at
      t.string :regular_holiday
      t.string :phone_number
      t.string :address, null: false
      t.float :latitude
      t.float :longitude
      t.integer :low_budget
      t.integer :high_budget
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :shops, :name, unique: true
    add_index :shops, :address, unique: true
  end
end
