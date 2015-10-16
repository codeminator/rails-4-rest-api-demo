json.cache! @activity do
  json.activity do
    json.cache! @activity do
      json.partial! 'activity', activity: @activity
    end
  end
end

