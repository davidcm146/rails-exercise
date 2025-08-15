require 'rails_helper'

RSpec.describe 'Job API', type: :request do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => JsonWebToken.encode(user_id: user.id) } }
  let!(:job) { create(:job, created_by: user) }

  describe 'GET /jobs/share/:share_link (public_view)' do
    let(:published_job) { create(:job, status: :published, share_link: 'abc123') }
    context 'when job is published' do
      it 'returns the job with status 200k' do
        get "/jobs/share/#{published_job.share_link}"
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(published_job.id)
      end
    end

    context 'when job not found or not published' do
      it 'returns 404' do
        get '/jobs/share/not_exist'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /jobs' do
    it 'returns jobs created by current user' do
      get '/jobs', headers: headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.first['id']).to eq(job.id)
    end
  end

  describe 'POST /jobs' do
    let(:valid_params) do
      { title: 'New Job', salary_from: 1000, salary_to: 2000 }
    end

    context 'with valid params' do
      it 'returns created job successfully' do
        expect do
          post '/jobs', params: valid_params, headers: headers
        end.to change(Job, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'returns errors' do
        post '/jobs', params: { title: '' }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /jobs/:id' do
    let(:update_params) { { title: 'Updated title' } }

    context 'when authorized' do
      it 'updates the job' do
        patch "/jobs/#{job.id}", params: update_params, headers: headers
        expect(response).to have_http_status(:ok)
        expect(job.reload.title).to eq('Updated title')
      end
    end

    context 'when unauthorized' do
      let(:other_user) { create(:user) }
      let!(:other_job) { create(:job, created_by: other_user) }
      let(:other_headers) { { 'Authorization' => JsonWebToken.encode(user_id: other_user.id) } }

      it 'returns forbidden' do
        patch "/jobs/#{other_job.id}", params: update_params, headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /jobs/:id' do
    context 'when authorized' do
      it 'deletes the job' do
        expect do
          delete "/jobs/#{job.id}", headers: headers
        end.to change(Job, :count).by(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when unauthorized' do
      let(:other_user) { create(:user) }
      let!(:other_job) { create(:job, created_by: other_user) }

      it 'returns forbidden' do
        delete "/jobs/#{other_job.id}", headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
