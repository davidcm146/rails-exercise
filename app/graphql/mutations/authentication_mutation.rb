module Mutations
  class AuthenticationMutation
    class Login < BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :errors, [String], null: true
      def resolve(email:, password:)
        user = User.find_by(email: email)
        raise GraphQL::ExecutionError, 'Invalid email or password' unless user&.authenticate(password)

        token = JsonWebToken.encode(user_id: user.id)
        { token: token, errors: [] }
      end
    end

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
end
