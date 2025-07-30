class ApplicationController < ActionController::API
  before_action :authorize
  attr_reader :current_user

  private

  def authorize
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user
  end
end
