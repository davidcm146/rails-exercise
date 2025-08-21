require 'rails_helper'

RSpec.describe 'Auth API', type: :request do # rubocop:disable Metrics/BlockLength
  let(:headers) { { CONTENT_TYPE: 'application/json' } }

  describe 'POST /register' do # rubocop:disable Metrics/BlockLength
    let(:valid_params) do
      attributes_for(:user).to_json
    end

    let(:invalid_params) do
      {
        full_name: '',
        email: 'invalid_email',
        password: '123',
        password_confirmation: '321'
      }.to_json
    end

    context 'when params are valid' do
      it 'register as a new user' do
        expect do
          post '/auth/register', params: valid_params, headers: headers
        end.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Register succesfully')
      end
    end

    context 'when params are invalid' do
      it 'returns unprocessable entity' do
        expect do
          post '/auth/register', params: invalid_params, headers: headers
        end.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe 'POST /auth/login' do # rubocop:disable Metrics/BlockLength
    let!(:user) { create(:user, email: Faker::Internet.unique.email, password: 'password') }

    context 'when credentials are valid' do
      it 'returns JWT token' do
        post '/auth/login',
             params: { email: user.email, password: 'password' },
             as: :json

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)
        expect(body).to include('token')
      end
    end

    context 'when credentials are invalid' do
      it 'returns unauthorized' do
        post '/auth/login',
             params: { email: user.email, password: 'wrong' },
             as: :json

        expect(response).to have_http_status(:unauthorized)

        body = JSON.parse(response.body)
        expect(body['errors']).to include('Invalid email or password')
      end
    end

    context 'when params are missing' do
      it 'returns 422 without body' do
        post '/auth/login',
             params: {},
             as: :json

        # debugger
        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body).to have_key('errors')
        expect(body['errors']['email']).to include("Email can't be blank", 'Email is invalid')
        expect(body['errors']['password']).to include("Password can't be blank")
      end
    end
  end

  describe 'DELETE /logout' do
    let!(:user) { create(:user, email: 'john@example.com', password: 'password') }
    let(:token) { JsonWebToken.encode(user_id: user.id) }
    let(:auth_headers) do
      {
        CONTENT_TYPE: 'application/json',
        Authorization: "Bearer #{token}"
      }
    end

    context 'when authenticated' do
      it 'returns 200 OK' do
        delete '/auth/logout', headers: auth_headers
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        delete '/auth/logout', headers: { CONTENT_TYPE: 'application/json' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
