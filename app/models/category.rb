class Category < ActiveRecord::Base
  has_and_belongs_to_many :mentor_asks, association_foreign_key: 'ask_id'
  validates :name, presence: true

  scope :admin_created, -> { where official: true }
end
