require 'rails_helper'

RSpec.describe Mutations::JobMutation, type: :graphql do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user) }
  let(:job) { create(:job, created_by: user) }
  describe 'CreateJob' do # rubocop:disable Metrics/BlockLength
    let(:query) do
      <<~GRAPHQL
        mutation($title: String!, $status: String!, $salaryFrom: Int, $salaryTo: Int) {
          createJob(input: { title: $title, status: $status, salaryFrom: $salaryFrom, salaryTo: $salaryTo }) {
            job {
              title
              status
              salaryFrom
              salaryTo
            }
            errors
          }
        }
      GRAPHQL
    end
    let(:user) { create(:user) }
    context 'when user logged in' do
      it 'returns created job' do
        result = RailsExerciseSchema.execute(
          query,
          variables: {
            title: 'Senior Rust Developer',
            status: 'published',
            salaryFrom: 2000,
            salaryTo: 4000
          },
          context: { current_user: user }
        )
        job_data = result.dig('data', 'createJob', 'job')
        errors_data = result.dig('data', 'createJob', 'errors')

        expect(job_data['title']).to eq('Senior Rust Developer')
        expect(job_data['status']).to eq('published')
        expect(job_data['salaryFrom']).to eq(2000)
        expect(job_data['salaryTo']).to eq(4000)
        expect(errors_data).to be_empty
      end
    end

    context 'when user is not logged in' do
      it 'raise authorized error' do
        result = RailsExerciseSchema.execute(
          query,
          variables: {
            title: 'Senior Rust Developer',
            status: 'published',
            salaryFrom: 2000,
            salaryTo: 4000
          },
          context: {}
        )
        job_data = result.dig('data', 'createJob', 'job')

        expect(job_data).to be_nil
        expect(result['errors'].first['message']).to eq('You must be logged in')
      end
    end
  end

  describe 'UpdateJob' do # rubocop:disable Metrics/BlockLength
    let(:query) do
      <<~GRAPHQL
        mutation($id: ID!, $title: String, $status: String) {
          updateJob(input: { id: $id, title: $title, status: $status }) {
            job {
              title
              status
            }
            errors
          }
        }
      GRAPHQL
    end

    context 'when user owns the job' do
      it 'updates job successfully' do
        result = RailsExerciseSchema.execute(
          query,
          variables: {
            id: job.id,
            title: 'Updated Title',
            status: 'published'
          },
          context: { current_user: user }
        )

        job_data = result.dig('data', 'updateJob', 'job')
        expect(job_data['title']).to eq('Updated Title')
        expect(job_data['status']).to eq('published')
      end
    end

    context 'when user does not own the job' do
      let(:other_job) { create(:job) }

      it 'returns authorization error' do
        expect do
          RailsExerciseSchema.execute(
            query,
            variables: {
              id: other_job.id,
              title: 'Updated Title'
            },
            context: { current_user: user }
          )
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe 'DeleteJob' do # rubocop:disable Metrics/BlockLength
    let(:query) do
      <<~GRAPHQL
        mutation($id: ID!) {
          deleteJob(input: { id: $id }) {
            message
            errors
          }
        }
      GRAPHQL
    end

    context 'when user owns the job' do
      it 'deletes the job' do
        job
        result = RailsExerciseSchema.execute(
          query,
          variables: { id: job.id },
          context: { current_user: user }
        )

        message_data = result.dig('data', 'deleteJob', 'message')
        errors_data = result.dig('data', 'deleteJob', 'errors')

        expect(message_data).to eq('Job deleted!')
        expect(errors_data).to be_empty
        expect(Job.exists?(job.id)).to be_falsey
      end
    end

    context 'when user does not own the job' do
      let(:other_job) { create(:job) }

      it 'returns authorization error' do
        expect do
          RailsExerciseSchema.execute(
            query,
            variables: { id: other_job.id },
            context: { current_user: user }
          )
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
