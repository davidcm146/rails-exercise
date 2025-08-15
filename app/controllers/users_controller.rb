# frozen_string_literal: true

class UsersController < ApplicationController
  def update
    user = User.find(@current_user.id)
    authorize user
    attach_avatar(user)
    if user.update(full_name: user_params[:full_name])
      render json: { message: 'User updated successfully!', user: UserSerializer.new(user) }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def attach_avatar(user)
    return if user_params[:avatar].blank?

    user.avatar.attach(user_params[:avatar])
  end

  def user_params
    params.permit(:full_name, :avatar)
  end
end
