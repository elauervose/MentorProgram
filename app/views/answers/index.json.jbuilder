json.array!(@answers) do |answer|
  json.extract! answer, :name, :email, :ask_id
  json.url answer_url(answer, format: :json)
end
