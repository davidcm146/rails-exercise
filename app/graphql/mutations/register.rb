module Mutations
  class Register < BaseMutation
    argument :data, Types::UserInputType, required: true

    field :message, String, null: true
    field :errors, [String], null: true

    def resolve(data:)
      user = User.new(
        full_name: data[:full_name],
        email: data[:email],
        password: data[:password],
        password_confirmation: data[:password_confirmation]
      )

      if user.save
        { message: 'Register successfully', errors: [] }
      else
        { message: nil, errors: user.errors.full_messages }
      end
    end
  end
end
