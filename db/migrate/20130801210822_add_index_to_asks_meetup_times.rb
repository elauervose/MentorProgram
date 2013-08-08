class AddIndexToAsksMeetupTimes < ActiveRecord::Migration
  def change
    add_index :asks_meetup_times, [:ask_id, :meetup_time_id], unique: true
  end
end
