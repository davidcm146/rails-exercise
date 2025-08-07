module Resolvers
  class JobResolver
    class MyJobs < Resolvers::BaseResolver
      type [Types::JobType], null: false

      def resolve
        authorize_user!
        policy_scope(Job)
      end
    end

    class PublicJobs < Resolvers::BaseResolver
      argument :share_link, String, required: true

      type Types::JobType, null: true

      def resolve(share_link:)
        job = Job.find_by(share_link: share_link)
        return job if job&.published?

        raise GraphQL::ExecutionError, 'Not found or not published'
      end
    end
  end
end
