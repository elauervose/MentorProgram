class CreateAsks < ActiveRecord::Migration
  def change
    create_table :asks do |t|
      t.string :name
      t.string :email
      t.string :location
      t.string :days
      t.string :times
      t.string :project_desc
      t.string :category

      t.timestamps
    end
  end
end
