class AddDescriptionEmailUpdatesAndAnsweredToAsks < ActiveRecord::Migration
  def change
    add_column :asks, :description, :text
    add_column :asks, :email_updates, :boolean
    add_column :asks,  :answered, :boolean
  end
end
