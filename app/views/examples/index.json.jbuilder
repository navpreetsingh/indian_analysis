json.array!(@examples) do |example|
  json.extract! example, 
  json.url example_url(example, format: :json)
end