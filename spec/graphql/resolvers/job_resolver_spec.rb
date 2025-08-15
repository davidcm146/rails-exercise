require 'rails_helper'

RSpec.describe Resolvers::JobResolver, type: :graphql do # rubocop:disable Metrics/BlockLength
  describe 'MyJobs' do # rubocop:disable Metrics/BlockLength
    let(:user) { create(:user) }
    let!(:job) { create(:job, created_by: user) }

    let(:query) do
      <<~GRAPHQL
        query {
          myJobs {
            id
            title
          }
        }
      GRAPHQL
    end

    context 'when user logged in' do
      it 'returns jobs for current user' do
        result = RailsExerciseSchema.execute(query, context: { current_user: user })
        jobs_data = result.dig('data', 'myJobs')

        expect(jobs_data.map(&:symbolize_keys)).to include(
          a_hash_including(id: job.id.to_s, title: job.title)
        )
      end
    end

    context 'when user is not logged in' do
      it 'returns login error' do
        result = RailsExerciseSchema.execute(query, context: {})
        expect(result['errors']).to be_present
        expect(result['errors'].first['message']).to eq('You must be logged in')
      end
    end
  end

  describe 'PublicJobs' do # rubocop:disable Metrics/BlockLength
    let!(:published_job) { create(:job, status: :published) }
    let!(:draft_job) { create(:job, status: :draft) }

    let(:query) do
      <<~GRAPHQL
        query($shareLink: String!) {
          publicJobs(shareLink: $shareLink) {
            id
            title
          }
        }
      GRAPHQL
    end

    context 'when job is published' do
      it 'returns detail job' do
        result = RailsExerciseSchema.execute(
          query,
          variables: { shareLink: published_job.share_link.to_s },
          context: {}
        )
        job_data = result.dig('data', 'publicJobs')
        expect(job_data).to include('id' => published_job.id.to_s, 'title' => published_job.title)
      end
    end

    context 'when job is draft' do
      it 'returns error not published' do
        result = RailsExerciseSchema.execute(
          query,
          variables: { shareLink: 'xyz123' },
          context: {}
        )
        expect(result['errors']).to be_present
        expect(result['errors'].first['message']).to eq('Not found or not published')
      end
    end

    context 'when job is not found' do
      it 'returns error not found' do
        result = RailsExerciseSchema.execute(
          query,
          variables: { shareLink: 'notfound' },
          context: {}
        )
        expect(result['errors']).to be_present
        expect(result['errors'].first['message']).to eq('Not found or not published')
      end
    end
  end
end
