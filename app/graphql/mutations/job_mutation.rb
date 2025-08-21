module Mutations
  class JobMutation
    class CreateJob < BaseMutation
      argument :data, Types::JobInputType

      field :job, Types::JobType, null: true
      field :errors, [String], null: false

      def resolve(data:)
        authorize_user!
        authorize Job, :create?
        result = Jobs::JobService::CreateService.new(current_user: context[:current_user], params: data.to_h).call
        if result.success?
          { job: result.data, errors: [] }
        else
          { job: nil, errors: result.errors.full_messages }
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
      argument :status, Integer, required: false

      field :job, Types::JobType, null: true
      field :errors, [String], null: false

      def resolve(id:, **attrs)
        authorize_user!
        job = Job.find(id)
        authorize job, :update?
        result = Jobs::JobService::UpdateService.new(job: job, params: attrs).call
        if result.success?
          { job: result.data, errors: [] }
        else
          { job: nil, errors: result.errors.full_messages }
        end
      end
    end
  end
end
