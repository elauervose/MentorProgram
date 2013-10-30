module Statistics
  SecondsInDay = 86400

  def average_response_time
    answered_requests = MentorAsk.answered_requests_with(self)
    average_response_in_days(answered_requests)
  end

  def median_response_time
    answered_requests = MentorAsk.answered_requests_with(self)
    median_response_in_days(answered_requests)
  end


  private

  def average_response_in_days(requests)
    average_response(requests) / SecondsInDay
  end

  def average_response(requests)
    times_array = response_times(requests)
    mean(times_array)
  end

  def median_response(requests)
    times_array = response_times(requests)
    median(times_array)
  end

  def response_times(requests)
    response_times = []
    requests.each do |request|
      response_times << request.answer.created_at - request.created_at
    end
    response_times
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

  def mean(values)
    values.inject(:+) / values.length
  end
      
end
