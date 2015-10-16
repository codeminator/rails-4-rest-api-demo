json.extract! venue, :id, :name, :latitude, :longitude, :created_by,
  :created_at, :updated_at

# embedded activities json
json.activities venue.activities do |activity|
  json.id activity.id
  json.name activity.name
  json.distance activity.distance
  json.measure_unit activity.measure_unit
  json.user_id activity.user_id
  json.venue_id venue.id
  json.created_at activity.created_at
  json.updated_at activity.updated_at
  json.url api_activity_url(activity, format: :json)
end
