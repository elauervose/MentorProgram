class AddIndexToAsksLocations < ActiveRecord::Migration
  def change
    add_index :asks_locations, [:ask_id, :location_id], unique: true
  end
end
