class MentorAsk < Ask
  has_and_belongs_to_many :categories, foreign_key: 'ask_id'
  accepts_nested_attributes_for :categories, reject_if:
    proc { |attributes| attributes['name'].blank? }
  after_create :create_token, :send_validation_email

  scope :with_category, ->(category) do
    return all if category.blank?
    joins(:categories).where('categories.id' => category)
  end

  scope :with_filters, ->(location, category, day, time) do
    with_location(location).with_category(category).with_day(day)
      .with_time(time)
  end

end
