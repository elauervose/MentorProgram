class AddOfficialToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :official, :boolean, default: false
  end
end
