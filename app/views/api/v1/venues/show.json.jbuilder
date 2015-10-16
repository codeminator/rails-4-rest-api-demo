json.cache! @venue do
  json.venue do
    json.cache! @venue do
      json.partial! 'venue', venue: @venue
    end
  end
end

