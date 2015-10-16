class Api::V1::ActivitiesController < ApplicationController

  load_and_authorize_resource

  # @page, @per_page calculated via Paginateable concern, included at ApplicationController

  def index
    @activities = Activity.paginate(page: @page, per_page: @per_page)
    render :index, status: :ok
  end

  def show
    
    render :show, status: :ok
  end

  def create
    @activity = current_user.activities.build(activity_params)
    @activity.save!
    render :show, status: :created
  end

  def update
    @activity.update!(activity_params)
    render :show, status: :ok
  end

  def destroy
    @activity.destroy!
    render json: {}, status: :no_content
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :distance, :measure_unit, :venue_id, :user_id)
  end
end
