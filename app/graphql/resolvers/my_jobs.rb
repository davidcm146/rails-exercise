module Resolvers
  class MyJobs < Resolvers::BaseResolver
    type [Types::JobType], null: false

    def resolve
      authorize_user!
      policy_scope(Job)
    end
  end
end
