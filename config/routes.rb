Rails.application.routes.draw do
  #-----API versioning
  api vendor_string: ENV['API_VENDOR'],
      default_version: ENV['API_DEFUALT_VERSION'],
      path: '' do
    version 1 do
      cache as: 'v1' do
        
      end
    end
  end
end
