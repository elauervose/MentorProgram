class CreateAsksCategories < ActiveRecord::Migration
  def change
    create_table :asks_categories do |t|
      t.belongs_to :ask
      t.belongs_to :category
    end
  end
end
