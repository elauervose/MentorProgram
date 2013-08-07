class CreateAsksMeetupTimes < ActiveRecord::Migration
  def change
    create_table :asks_meetup_times do |t|
      t.belongs_to :ask
      t.belongs_to :meetup_time
    end
  end
end
