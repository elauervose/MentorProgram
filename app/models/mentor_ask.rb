class MentorAsk < Ask
  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :categories, reject_if:
    proc { |attributes| attributes['name'].blank? }

  scope :with_category, ->(category) do
    if category.blank?
      all
    else
      joins(:categories).where('categories.id' => category)
    end
  end
  scope :with_filters, ->(location, category, day, time) do
    with_location(location).with_category(category).with_day(day)
      .with_time(time)
  end
end
