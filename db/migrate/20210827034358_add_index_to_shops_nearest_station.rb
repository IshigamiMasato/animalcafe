class AddIndexToShopsNearestStation < ActiveRecord::Migration[6.1]
  def change
    add_index :shops, :nearest_station
  end
end
