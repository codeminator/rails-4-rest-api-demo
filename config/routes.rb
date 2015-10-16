Rails.application.routes.draw do
  
  devise_for :users
  #-----API versioning
  api vendor_string: ENV['API_VENDOR'],
      default_version: ENV['API_DEFUALT_VERSION'],
      path: '' do
    version 1 do
      cache as: 'v1' do
        resources :activities
        resources :venues
      end
    end
  end
  # catch 404 error
  match "*path", to: -> (env) { [404, {}, ['{"errors": "Resource not found"}']] }, via: :all
end
