class CreateAsksLocations < ActiveRecord::Migration
  def change
    create_table :asks_locations do |t|
      t.belongs_to :ask
      t.belongs_to :location
    end
  end
end
