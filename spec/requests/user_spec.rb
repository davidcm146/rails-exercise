require 'rails_helper'

RSpec.describe 'User API', type: :request do # rubocop:disable Metrics/BlockLength
  let!(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) do
    {
      CONTENT_TYPE: 'application/json',
      Authorization: "Bearer #{token}"
    }
  end

  let(:avatar_file) do
    fixture_file_upload(Rails.root.join('spec/factories/files/shutup.jpg'), 'image/jpg')
  end

  # describe 'POST /graphql' do
  #   let(:query) do
  #     <<~GRAPHQL
  #       mutation($fullName: String!, $avatar: Upload!) {
  #         updateProfile(input: { fullName: $fullName, avatar: $avatar }) {
  #           user {
  #             id
  #             fullName
  #             avatar
  #           }
  #         }
  #       }
  #     GRAPHQL
  #   end
  #   context 'when user update profile successfully with graphQL' do
  #     it 'returns updated user info' do
  #       post '/graphql',
  #            params: {
  #              query: query,
  #              variables: { avatar: nil },
  #              operations: {
  #                query: query,
  #                variables: { fullName: Faker::Name.name, avatar: nil }
  #              }.to_json,
  #              map: { '0' => ['variables.avatar'] }.to_json,
  #              '0' => avatar_file
  #            }, headers: headers
  #       debugger
  #       user_data = result.dig('data', 'updateProfile', 'user')
  #       expect(user_data['fullName']).to eq(full_name)
  #       expect(user.reload.full_name).to eq(full_name)
  #     end
  #   end
  # end

  describe 'PATCH /profile' do # rubocop:disable Metrics/BlockLength
    context 'when params are valid' do
      let(:valid_params) do
        { full_name: Faker::Name.name }.to_json
      end

      it "updates the user's full_name" do
        patch '/profile', params: valid_params, headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('User updated successfully!')
        parsed_params = JSON.parse(valid_params)['full_name']
        expect(json['user']['full_name']).to eq(parsed_params)
        expect(user.reload.full_name).to eq(parsed_params)
      end
    end

    context 'when attaching avatar' do
      it 'attaches the avatar' do
        patch '/profile',
              params: { user: { full_name: Faker::Name.name, avatar: avatar_file } },
              headers: headers

        expect(response).to have_http_status(:ok)
        expect(user.reload.avatar).to be_attached
      end

      let(:user_with_avatar) { create(:user, :with_avatar) }
      it 'purges old avatar and attaches new one' do
        old_blob_id = user_with_avatar.avatar.blob.id

        patch '/profile', params: { user: { full_name: Faker::Name.name, avatar: avatar_file } }, headers: headers

        expect(response).to have_http_status(:ok)

        user.reload

        expect(user.avatar).to be_attached
        expect(user.avatar.blob.id).not_to eq(old_blob_id)
      end
    end

    context 'when params are invalid' do
      let(:invalid_params) do
        { user: { full_name: '' } }.to_json
      end

      it 'returns errors' do
        patch '/profile', params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body['errors']['full_name']).to include('can\'t be blank')
      end
    end
  end
end
