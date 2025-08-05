module Mutations
  class UpdateProfile < BaseMutation
    argument :id, ID, required: true
    argument :avatar, ApolloUploadServer::Upload, required: false
    argument :full_name, String, required: false

    field :user, Types::UserType

    def resolve(id:, full_name: nil, avatar: nil)
      authorize_user!
      user = User.find(id)
      authorize user, :update?

      user.full_name = full_name if full_name.present?
      user.avatar.attach(io: avatar, filename: avatar.original_filename) if avatar.present?

      user.save!
      { user: user }
    end
  end
end
