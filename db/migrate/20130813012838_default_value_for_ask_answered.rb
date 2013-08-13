class DefaultValueForAskAnswered < ActiveRecord::Migration
  def change
    change_table :asks do |t|
      t.change_default :answered, false 
    end
  end
end
