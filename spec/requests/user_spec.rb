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

  describe 'PATCH /profile/:id' do # rubocop:disable Metrics/BlockLength
    context 'when params are valid' do
      let(:valid_params) do
        { full_name: 'Updated Name' }.to_json
      end

      it "updates the user's full_name" do
        patch "/profile/#{user.id}", params: valid_params, headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('User updated successfully!')
        expect(json['user']['full_name']).to eq('Updated Name')
        expect(user.reload.full_name).to eq('Updated Name')
      end
    end

    context 'when attaching avatar' do
      let(:avatar_file) do
        fixture_file_upload(Rails.root.join('spec/factories/files/shutup.jpg'), 'image/jpg')
      end

      it 'attaches the avatar' do
        patch "/profile/#{user.id}",
              params: { full_name: 'With Avatar', avatar: avatar_file },
              headers: headers

        expect(response).to have_http_status(:ok)
        expect(user.reload.avatar).to be_attached
      end
    end

    context 'when params are invalid' do
      let(:invalid_params) do
        { full_name: '' }.to_json
      end

      it 'returns errors' do
        patch "/profile/#{user.id}", params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json).to have_key('errors')
      end
    end
  end
end
