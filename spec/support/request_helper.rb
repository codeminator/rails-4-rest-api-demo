module Requests
  module APIHelpers
    def request_headers(v = 1)
      {
        HTTP_CONTENT_TYPE: 'application/json',
        HTTP_ACCEPT: "application/vnd.#{ENV['API_VENDOR']}+json; version=#{v}"
      } 
    end
  end
end
