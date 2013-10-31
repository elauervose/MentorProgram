class AddValidatedAtToAsks < ActiveRecord::Migration
  def change
    add_column :asks, :validated_at, :datetime
  end
end
