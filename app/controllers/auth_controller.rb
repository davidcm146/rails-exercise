# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :authorize_request, only: %i[register login]

  def register
    result = Authentication::AuthenticationService::RegisterService.new(user_params).call
    if result.success?
      render json: { message: 'Register succesfully' }, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def login
    result = Authentication::AuthenticationService::LoginService.new(user_params).call

    if result.success?
      render json: { token: result.data }, status: :ok
    else
      errors = result.errors

      if errors[:base].present?
        render json: { errors: errors[:base] }, status: :unauthorized
      else
        render json: { errors: errors.to_hash(true) }, status: :unprocessable_entity
      end
    end
  end

  def logout
    head :ok
  end

  private

  def user_params
    params.permit(:full_name, :email, :password, :password_confirmation)
  end
end
