class CreateMeetupTimes < ActiveRecord::Migration
  def change
    create_table :meetup_times do |t|
      t.string :day
      t.string :period
      t.timestamps
    end
  end
end
