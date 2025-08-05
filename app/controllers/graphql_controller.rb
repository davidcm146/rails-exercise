# frozen_string_literal: true

class GraphqlController < ApplicationController
  include Pundit
  skip_before_action :authorize_request
  def execute
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded

    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    context = {
      current_user: @current_user
    }

    result = RailsExerciseSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )
    render json: result
  rescue ActiveRecord::RecordNotFound => e
    raise GraphQL::ExecutionError, 'Record not found'
  rescue Pundit::NotAuthorizedError => e
    render json: {
      errors: [{ message: 'You are not authorized to perform this action' }],
      data: {}
    }, status: :forbidden
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  def pundit_user
    @current_user
  end

  def prepare_variables(variables_param)
    case variables_param
    when String
      variables_param.present? ? JSON.parse(variables_param) : {}
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render json: {
      errors: [{ message: e.message, backtrace: e.backtrace }],
      data: {}
    }, status: :internal_server_error
  end
end
