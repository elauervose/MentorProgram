module ApplicationHelper
  def full_title
    if @title.blank?
      "Mentor Program"
    else
      @title + " || Mentor Program"
    end
  end
end
