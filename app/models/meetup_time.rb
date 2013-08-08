class MeetupTime < ActiveRecord::Base
  has_and_belongs_to_many :asks
end
