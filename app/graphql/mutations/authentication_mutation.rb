module Mutations
  class AuthenticationMutation
    class Login < BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :errors, [String], null: true
      def resolve(email:, password:)
        result = Authentication::AuthenticationService::LoginService.new(email: email, password: password).call
        raise GraphQL::ExecutionError, result.errors.full_messages unless result.success?

        { token: result.data, errors: [] }
      end
    end

    class Register < BaseMutation
      argument :data, Types::UserInputType, required: true

      field :message, String, null: true
      field :errors, [String], null: true

      def resolve(data:)
        result = Authentication::AuthenticationService::RegisterService.new(data.to_h).call

        if result.success?
          { message: 'Register successfully', errors: [] }
        else
          { message: nil, errors: result.errors.full_messages }
        end
      end
    end
  end
end
