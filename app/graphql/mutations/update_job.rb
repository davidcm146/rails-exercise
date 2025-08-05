module Mutations
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
