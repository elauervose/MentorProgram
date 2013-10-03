module Statistics
  #extend ActiveSupport::Concern

  SecondsInDay = 86400

  def average_response_in_days(requests)
    average_response(requests) / SecondsInDay
  end

  def average_response(requests)
    total_time = 0
    requests.each do |request|
      total_time += request.answer.created_at - request.created_at
    end
    total_time / requests.count
  end

  def median_response(requests)
    response_times = []
    requests.each do |request|
      response_times << request.answer.created_at - request.created_at
    end
    median(response_times)
  end

  def median_response_in_days(requests)
    median_response(requests) / SecondsInDay
  end
  
  def median(values)
    sorted_values = values.sort
    array_size = sorted_values.length
    if array_size % 2 == 1
      sorted_values[array_size / 2]
    else
      (sorted_values[array_size / 2] + sorted_values[(array_size / 2) - 1]) / 2
    end
  end
      
end
