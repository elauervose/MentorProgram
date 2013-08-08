class AddIndexToAsksCategories < ActiveRecord::Migration
  def change
    add_index :asks_categories, [:ask_id, :category_id], unique: true
  end
end
