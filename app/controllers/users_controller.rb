class UsersController < ApplicationController
  def update
    user = User.find(@current_user.id)
    authorize user
    if user_params[:avatar].present?
      user.avatar.attach(user_params[:avatar])
    end
    if user.update(full_name: user_params[:full_name])
      render json: { message: 'User updated successfully!', user: UserSerializer.new(user) }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:full_name, :avatar)
  end
end
