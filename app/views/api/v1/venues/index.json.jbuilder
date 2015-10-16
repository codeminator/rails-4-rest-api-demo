if @venues.empty?
  json.venues []
else
  json.cache! @venues, skip_digest: true do
    json.venues do
      json.cache_collection! @venues do |venue|
        json.partial! 'venue', venue: venue
        json.url api_venue_url(venue, format: :json)
      end
    end
    json.meta do
      json.partial! 'api/v1/shared/paging', total: Venue.count
    end
  end
end

