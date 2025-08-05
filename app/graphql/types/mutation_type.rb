# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :register, mutation: Mutations::Register
    field :test_field, mutation: Mutations::TestField
    field :login, mutation: Mutations::Login
    field :update_profile, mutation: Mutations::UpdateProfile
    field :create_job, mutation: Mutations::CreateJob
    field :update_job, mutation: Mutations::UpdateJob
    field :delete_job, mutation: Mutations::DeleteJob
  end
end
