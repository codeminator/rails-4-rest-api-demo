module ExceptionHandlable
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::ParameterMissing, with: :rescue_bad_request
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :rescue_unprocessable_entity
    rescue_from ActiveRecord::UnknownAttributeError, with: :rescue_unprocessable_entity
    rescue_from CanCan::AccessDenied, with: :rescue_access_denied
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
      errors: { message: errors.record.errors.full_messages }
    } if errors.record

    render json: errors, status: :unprocessable_entity
  end

  # 403 Forbidden
  def rescue_access_denied(exception)
    errors = {
      errors: { message: exception.message }
    }
    render json: errors, status: :forbidden
  end
end