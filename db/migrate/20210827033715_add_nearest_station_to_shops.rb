class AddNearestStationToShops < ActiveRecord::Migration[6.1]
  def change
    add_column :shops, :nearest_station, :string
  end
end
