module Mutations
  class Login < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :error, String, null: true
    def resolve(email:, password:)
      user = User.find_by(email: email)
      raise GraphQL::ExecutionError, 'Invalid email or password' unless user&.authenticate(password)

      token = JsonWebToken.encode(user_id: user.id)
      { token: token, error: nil }
    end
  end
end
