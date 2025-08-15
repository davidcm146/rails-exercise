module Authorizable
  include Pundit::Authorization
  def current_user
    context[:current_user]
  end

  def authorize_user!
    raise GraphQL::ExecutionError, 'You must be logged in' unless current_user
  end
end
