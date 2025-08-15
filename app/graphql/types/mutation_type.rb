# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :register, mutation: Mutations::AuthenticationMutation::Register
    field :login, mutation: Mutations::AuthenticationMutation::Login
    field :update_profile, mutation: Mutations::ProfileMutation::UpdateProfile
    field :create_job, mutation: Mutations::JobMutation::CreateJob
    field :update_job, mutation: Mutations::JobMutation::UpdateJob
    field :delete_job, mutation: Mutations::JobMutation::DeleteJob
  end
end
