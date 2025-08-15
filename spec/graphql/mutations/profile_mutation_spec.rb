require 'rails_helper'

RSpec.describe Mutations::ProfileMutation, type: :graphql do # rubocop:disable Metrics/BlockLength
  describe 'Update profile' do # rubocop:disable Metrics/BlockLength
    let(:query) do
      <<~GRAPHQL
        mutation($id: ID!, $fullName: String, $avatar: Upload) {
          updateProfile(input: { id: $id, fullName: $fullName, avatar: $avatar }) {
            user {
              id
              fullName
            }
          }
        }
      GRAPHQL
    end
    let(:user) { create(:user, full_name: 'Old Name') }
    let(:avatar_file) do
      double(
        'Upload',
        original_filename: 'shutup.jpg',
        content_type: 'image/jpg',
        to_io: File.open(Rails.root.join('spec/factories/files/shutup.jpg'))
      )
    end

    context 'when user update profile successfully' do
      it 'returns updated user info' do
        result = RailsExerciseSchema.execute(
          query,
          variables: {
            id: user.id,
            fullName: 'New Name'
            # avatar: avatar_file
          },
          context: { current_user: user }
        )
        p result
        user_data = result.dig('data', 'updateProfile', 'user')
        expect(user_data['id']).to eq(user.id.to_s)
        expect(user_data['fullName']).to eq('New Name')
        expect(user.reload.full_name).to eq('New Name')
      end
    end

    context 'when user is not logged in' do
      it 'raises not logged in error' do
        result = RailsExerciseSchema.execute(
          query,
          variables: {
            id: user.id,
            fullName: 'New Name'
          },
          context: {}
        )

        expect(result['errors']).to be_present
        expect(result['errors'].first['message']).to eq('You must be logged in')
      end
    end

    context 'when user tries to update another user' do
      let(:other_user) { create(:user) }

      it 'raise authorization error' do
        expect do
          RailsExerciseSchema.execute(
            query,
            variables: {
              id: other_user.id,
              fullName: 'Hacker Name'
            },
            context: { current_user: user }
          )
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
