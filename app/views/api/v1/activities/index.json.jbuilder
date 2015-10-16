if @activities.empty?
  json.activities []
else
  json.cache! @activities, skip_digest: true do
    json.activities do
      json.cache_collection! @activities do |activity|
        json.partial! 'activity', activity: activity
        json.url api_activity_url(activity, format: :json)
      end
    end
    json.meta do
      json.partial! 'api/v1/shared/paging', total: Activity.count
    end
  end
end

