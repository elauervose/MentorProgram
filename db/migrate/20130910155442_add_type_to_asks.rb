class AddTypeToAsks < ActiveRecord::Migration
  def change
    add_column :asks, :type, :string
  end
end
