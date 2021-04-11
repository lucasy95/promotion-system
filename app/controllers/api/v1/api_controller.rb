class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  rescue_from ActionController::ParameterMissing, with: :param_miss
  respond_to :json

  private

  def not_found_error
    head 404
  end

  def param_miss
    head 422
  end
end
