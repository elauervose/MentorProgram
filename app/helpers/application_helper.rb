module ApplicationHelper
  def full_title
    if @title.blank?
      "Mentor Program"
    else
      @title + " || Mentor Program"
    end
  end

  def days_of_week
    %w{Monday Tuesday Wednesday Thursday Friday Saturday Sunday}
  end

  def times_to_meet
    ["Morning", "Afternoon", "Evening"]
  end
end
