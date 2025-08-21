require 'rails_helper'

RSpec.describe Mutations::ProfileMutation, type: :graphql do # rubocop:disable Metrics/BlockLength
  describe 'Update profile' do # rubocop:disable Metrics/BlockLength
    let(:query) do
      <<~GRAPHQL
        mutation($fullName: String, $avatar: Upload) {
          updateProfile(input: { fullName: $fullName, avatar: $avatar }) {
            user {
              id
              fullName
            }
          }
        }
      GRAPHQL
    end
    let(:user) { create(:user, full_name: Faker::Name.name) }
    let(:full_name) { Faker::Name.name }
    # let(:avatar_file) do
    #   double(
    #     'Upload',
    #     original_filename: 'shutup.jpg',
    #     content_type: 'image/jpg',
    #     to_io: File.open(Rails.root.join('spec/factories/files/shutup.jpg'))
    #   )
    # end

    context 'when user is not logged in' do
      it 'raises not logged in error' do
        result = RailsExerciseSchema.execute(
          query,
          variables: {
            fullName: full_name
          },
          context: {}
        )

        expect(result['errors']).to be_present
        expect(result['errors'].first['message']).to eq('You must be logged in')
      end
    end
  end
end
