# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :authorize_request, only: %i[register login]

  def register
    @user = User.new(user_params)
    if @user.save
      render json: { message: 'Register succesfully' }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      Rails.logger.debug token: token
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
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
