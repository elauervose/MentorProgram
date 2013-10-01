module Locatable

  def add_locations(locations)
    if locations
      locations.each { |location| @ask.locations << Location.find(location) }
    end
  end

  def update_locations(locations)
    if locations
      location_ids = locations.collect { |location| location.to_i }
      @ask.locations = Location.find(location_ids)
    else
      @ask.locations.clear
    end
  end

end
