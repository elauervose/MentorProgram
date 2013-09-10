class Category < ActiveRecord::Base
  has_and_belongs_to_many :mentor_asks
  validates :name, presence: true

  scope :admin_created, -> { where official: true }
end
