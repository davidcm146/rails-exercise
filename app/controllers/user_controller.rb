class UserController < ApplicationController
  # before_action :set_user, only: %i[ update ]

  def update
    @user = User.find(@current_user.id)
    if user_params[:avatar].present?
      @user.avatar.attach(user_params[:avatar])
    end
    if @user.update(full_name: user_params[:full_name])
      render json: { message: 'User updated successfully', user: UserSerializer.new(@user) }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def user_params
    params.permit(:full_name, :avatar)
  end
end
