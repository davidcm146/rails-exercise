module Mutations
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
end
