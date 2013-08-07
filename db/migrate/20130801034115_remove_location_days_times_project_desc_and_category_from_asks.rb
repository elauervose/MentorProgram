class RemoveLocationDaysTimesProjectDescAndCategoryFromAsks < ActiveRecord::Migration
  def up
    remove_column :asks, :location
    remove_column :asks, :days
    remove_column :asks, :times
    remove_column :asks, :project_desc
    remove_column :asks, :category
  end

  def down
    add_column :asks, :location, :string
    add_column :asks, :days, :string
    add_column :asks, :times, :string
    add_column :asks, :project_desc, :string
    add_column :asks, :category, :string
  end
end
