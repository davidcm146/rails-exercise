require 'rails_helper'

RSpec.describe Mutations::AuthenticationMutation, type: :graphql do # rubocop:disable Metrics/BlockLength
  describe 'Register' do # rubocop:disable Metrics/BlockLength
    let(:query) do
      <<~GRAPHQL
        mutation($data: UserInput!) {
          register(input: { data: $data }) {
            message
            errors
          }
        }
      GRAPHQL
    end
    context 'when user register successfully' do
      it 'returns 201 created and success message' do
        result = RailsExerciseSchema.execute(
          query,
          variables: {
            data: {
              fullName: 'davidjr',
              email: 'davidjr@gmail.com',
              password: '123456',
              passwordConfirmation: '123456'
            }
          },
          context: {}
        )
        register_data = result.dig('data', 'register')

        expect(register_data['message']).to eq('Register successfully')
        expect(register_data['errors']).to be_empty
      end
    end

    context 'when no params are passed to register' do
      it 'returns invalid params errors' do
        result = RailsExerciseSchema.execute(
          query,
          variables: {
            data: {}
          },
          context: {}
        )
        p result
        register_data = result.dig('data', 'register')

        if register_data.nil?
          expect(result['errors']).to be_present
        else
          expect(register_data['message']).to be_nil
          expect(register_data['errors']).to be_present
        end
      end
    end

    context 'when password and confirmation do not match' do
      it 'returns password confirmation error' do
        result = RailsExerciseSchema.execute(
          query,
          variables: {
            data: {
              fullName: 'David Jr',
              email: 'davidjr@example.com',
              password: '123456',
              passwordConfirmation: '654321'
            }
          },
          context: {}
        )

        register_data = result.dig('data', 'register')
        expect(register_data['message']).to be_nil
        expect(register_data['errors']).to include("Password confirmation doesn't match Password")
      end
    end

    context 'when email already exists' do
      let!(:existing_user) { create(:user, email: 'existing@example.com') }

      it 'returns email taken error' do
        result = RailsExerciseSchema.execute(
          query,
          variables: {
            data: {
              fullName: 'Existing User',
              email: 'existing@example.com',
              password: '123456',
              passwordConfirmation: '123456'
            }
          },
          context: {}
        )

        register_data = result.dig('data', 'register')
        expect(register_data['message']).to be_nil
        expect(register_data['errors']).to include('Email has already been taken')
      end
    end
  end

  describe 'Login' do # rubocop:disable Metrics/BlockLength
    let(:query) do
      <<~GRAPHQL
        mutation($email: String!, $password: String!) {
          login(input: { email: $email, password: $password }) {
            token
            errors
          }
        }
      GRAPHQL
    end

    let!(:user) { create(:user, email: 'test@example.com', password: '123456') }

    context 'when credentials are valid' do
      it 'returns a token' do
        result = RailsExerciseSchema.execute(
          query,
          variables: { email: 'test@example.com', password: '123456' },
          context: {}
        )

        login_data = result.dig('data', 'login')
        expect(login_data['token']).to be_present
        expect(login_data['errors']).to be_empty
      end
    end

    context 'when credentials are invalid' do
      it 'raises invalid credentials error' do
        result = RailsExerciseSchema.execute(
          query,
          variables: { email: 'test@example.com', password: 'wrongpass' },
          context: {}
        )
        expect(result['data']['login']).to be_nil
        expect(result['errors'].first['message']).to eq('Invalid email or password')
      end
    end
  end
end
