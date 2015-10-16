module Paginateable
  extend ActiveSupport::Concern

  included do
  	before_filter :set_pagination_params, only: [:index]
  end

  def set_pagination_params
  	@page = (params[:page] || configatron.api.current_page).to_i
  	# Protection against page is negative
  	@page = configatron.api.current_page.to_i if @page < 0
	@per_page = (params[:per_page] || configatron.api.per_page).to_i
	# Protection against large per_page param sent || per_page is negative
  	if @per_page > configatron.api.max_allowed_per_page || @per_page < 0
  		@per_page = configatron.api.max_allowed_per_page
  	end
  end
end