class Ask < ActiveRecord::Base
  has_one :answer
  has_and_belongs_to_many :locations
end
