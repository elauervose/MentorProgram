class AddTokenToAsks < ActiveRecord::Migration
  def change
    add_column :asks, :token, :string
  end
end
