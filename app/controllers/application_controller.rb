# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pundit::Authorization
  before_action :authorize_request
  attr_reader :current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user
  end

  def user_not_authorized(exception)
    render json: {
      error: 'You are not authorized to perform this action.',
      policy: exception.policy.class.to_s,
      query: exception.query
    }, status: :forbidden
  end
end
