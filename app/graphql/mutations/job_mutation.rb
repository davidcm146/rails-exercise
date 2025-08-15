module Mutations
  class JobMutation
    class CreateJob < BaseMutation
      argument :title, String, required: true
      argument :published_date, GraphQL::Types::ISO8601Date, required: false
      argument :salary_from, Integer, required: false
      argument :salary_to, Integer, required: false
      argument :status, String, required: true
      argument :share_link, String, required: false

      field :job, Types::JobType, null: true
      field :errors, [String], null: false

      def resolve(title:, status:, published_date: nil, salary_from: nil, salary_to: nil, share_link: nil) # rubocop:disable Metrics/ParameterLists
        authorize_user!
        job = current_user.jobs.build(
          title: title,
          published_date: published_date,
          salary_from: salary_from,
          salary_to: salary_to,
          status: status,
          share_link: share_link
        )
        authorize job, :create?
        if job.save
          { job: job, errors: [] }
        else
          { job: nil, errors: job.errors.full_messages }
        end
      end
    end

    class DeleteJob < BaseMutation
      argument :id, ID, required: true

      field :message, String, null: true
      field :errors, [String], null: false

      def resolve(id:)
        authorize_user!
        job = Job.find(id)
        authorize job, :destroy?
        job.destroy
        { message: 'Job deleted!', errors: [] }
      end
    end

    class UpdateJob < BaseMutation
      argument :id, ID, required: true
      argument :title, String, required: false
      argument :published_date, GraphQL::Types::ISO8601Date, required: false
      argument :salary_from, Integer, required: false
      argument :salary_to, Integer, required: false
      argument :status, String, required: false
      argument :share_link, String, required: false

      field :job, Types::JobType, null: true
      field :errors, [String], null: false

      def resolve(id:, **attrs)
        authorize_user!
        job = Job.find(id)
        authorize job, :update?
        if job.update(attrs)
          { job: job, errors: [] }
        else
          { job: nil, errors: job.errors.full_messages }
        end
      end
    end
  end
end
