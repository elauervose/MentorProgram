json.array!(@asks) do |ask|
  json.extract! ask, :name, :email, :location, :days, :times, :project_desc, :category
  json.url ask_url(ask, format: :json)
end
