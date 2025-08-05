module Types
  class UserInputType < Types::BaseInputObject
    graphql_name 'UserInput'

    argument :full_name, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true
  end
end
