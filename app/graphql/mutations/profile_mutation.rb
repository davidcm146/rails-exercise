module Mutations
  class ProfileMutation
    class UpdateProfile < BaseMutation
      argument :avatar, ApolloUploadServer::Upload, required: false
      argument :full_name, String, required: false

      field :user, Types::UserType

      def resolve(full_name: nil, avatar: nil)
        authorize_user!
        authorize context[:current_user], :update?

        result = Users::UserService::UpdateProfileService.new(
          current_user: context[:current_user],
          params: {
            full_name: full_name,
            avatar: avatar
          }
        ).call

        raise GraphQL::ExecutionError, result.errors.full_messages unless result.success?

        { user: result.data }
      end
    end
  end
end
