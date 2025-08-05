module Mutations
  class CreateJob < BaseMutation
    argument :title, String, required: true
    argument :published_date, GraphQL::Types::ISO8601Date, required: false
    argument :salary_from, Integer, required: false
    argument :salary_to, Integer, required: false
    argument :status, String, required: true
    argument :share_link, String, required: false

    field :job, Types::JobType, null: true
    field :errors, [String], null: false

    def resolve(args)
      authorize_user!
      job = current_user.jobs.build(args)
      authorize job, :create?
      if job.save
        { job: job, errors: [] }
      else
        { job: nil, errors: job.errors.full_messages }
      end
    end
  end
end
