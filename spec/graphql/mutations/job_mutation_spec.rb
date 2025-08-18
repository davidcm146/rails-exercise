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
    let(:title) { Faker::Job.title }
    let(:status) { 'published' }
    let(:salary_from) { Faker::Number.between(from: 1000, to: 3000) }
    let(:salary_to) { Faker::Number.between(from: salary_from + 500, to: salary_from + 5000) }

    context 'when user logged in' do
      it 'returns created job' do
        result = RailsExerciseSchema.execute(
          query,
          variables: {
            title: title,
            status: status,
            salaryFrom: salary_from,
            salaryTo: salary_to
          },
          context: { current_user: user }
        )

        job_data = result.dig('data', 'createJob', 'job')
        errors_data = result.dig('data', 'createJob', 'errors')

        expect(job_data['title']).to eq(title)
        expect(job_data['status']).to eq(status)
        expect(job_data['salaryFrom']).to eq(salary_from)
        expect(job_data['salaryTo']).to eq(salary_to)
        expect(errors_data).to be_empty
      end
    end

    context 'when user is not logged in' do
      it 'raise authorized error' do
        result = RailsExerciseSchema.execute(
          query,
          variables: {
            title: title,
            status: status,
            salaryFrom: salary_from,
            salaryTo: salary_to
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
      let(:updated_title) { Faker::Job.title }
      let(:status) { 'published' }
      it 'updates job successfully' do
        result = RailsExerciseSchema.execute(
          query,
          variables: {
            id: job.id,
            title: updated_title,
            status: status
          },
          context: { current_user: user }
        )

        job_data = result.dig('data', 'updateJob', 'job')
        expect(job_data['title']).to eq(updated_title)
        expect(job_data['status']).to eq(status)
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
