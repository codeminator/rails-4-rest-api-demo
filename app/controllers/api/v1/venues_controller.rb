class Api::V1::VenuesController < ApplicationController

  load_and_authorize_resource

  # @page, @per_page calculated via Paginateable concern, included at ApplicationController

  def index
    @venues = Venue.paginate(page: @page, per_page: @per_page)
    render :index, status: :ok
  end

  def show
    render :show, status: :ok
  end

  def create
    @venue = current_user.venues.build(venue_params)
    @venue.save!
    render :show, status: :created
  end

  def update
    @venue.update!(venue_params)
    render :show, status: :ok
  end

  def destroy
    @venue.destroy!
    render json: {}, status: :no_content
  end

  private

  def venue_params
    params.require(:venue).permit(:name, :latitude, :longitude)
  end
end
