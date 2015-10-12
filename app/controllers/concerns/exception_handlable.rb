module ExceptionHandlable
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::ParameterMissing, with: :rescue_bad_request
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :rescue_unprocessable_entity
    rescue_from CanCan::AccessDenied, with: :rescue_access_denied
    rescue_from Exception, with: :rescue_internal_server_error
  end

  # 400 Bad Request
  def rescue_bad_request(errors = {})
    errors = { message: "Missing Parameter #{errors.param}" }
    render json: { errors: errors }, status: :bad_request
  end

  # 404 Not Found
  def rescue_not_found(errors = {})
    errors = { message: 'Record Not Found' }
    render json: { errors: errors }, status: :not_found
  end

  # 422 Unprocessable Entity
  def rescue_unprocessable_entity(errors = {})
    errors = {
      message: errors.record.errors.full_messages
    } if errors.record

    render json: errors, status: :unprocessable_entity
  end

  # 403 Forbidden
  def rescue_access_denied(exception)
    render json: exception.message, status: :forbidden
  end

  # 500 Internal Server Error
  def rescue_internal_server_error(errors = {})
    render json: errors, status: :internal_server_error
  end
end