# frozen_string_literal: true

module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    include Pundit

    def current_user
      context[:current_user]
    end

    def authorize_user!
      raise GraphQL::ExecutionError, 'You must be logged in' unless current_user
    end
    # def authorize(record, query)
    #   policy = Pundit.policy!(current_user, record)
    #   raise Pundit::NotAuthorizedError unless policy.public_send(query)
    # end
  end
end
