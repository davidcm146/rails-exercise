# frozen_string_literal: true

class UsersController < ApplicationController
  def update
    user = User.find(@current_user.id)
    authorize user

    attach_avatar(user)
    result = Users::UserService::UpdateProfileService.new(current_user: @current_user, params: user_params).call
    if result.success?
      render json: {
        message: 'User updated successfully!',
        user: UserSerializer.new(result.data)
      }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def attach_avatar(user)
    return if user_params[:avatar].blank?

    user.avatar.attach(user_params[:avatar])
  end

  def user_params
    params.require(:user).permit(:full_name, :avatar)
  end
end
