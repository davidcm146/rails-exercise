require 'rails_helper'

RSpec.describe JobPolicy, type: :policy do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:job) { create(:job, created_by: user) }
  let(:other_job) { create(:job, created_by: other_user) }

  describe '#create?' do
    subject { described_class.new(current_user, Job.new) }

    context 'when user is present' do
      let(:current_user) { user }
      it { is_expected.to be_create }
    end

    context 'when user is nil' do
      let(:current_user) { nil }
      it { is_expected.not_to be_create }
    end
  end

  describe '#update?' do
    subject { described_class.new(current_user, record) }

    context 'when user owns the job' do
      let(:current_user) { user }
      let(:record) { job }
      it { is_expected.to be_update }
    end

    context 'when user does not own the job' do
      let(:current_user) { user }
      let(:record) { other_job }
      it { is_expected.not_to be_update }
    end
  end

  describe '#index?' do
    subject { described_class.new(current_user, record) }

    context 'when user owns the job' do
      let(:current_user) { user }
      let(:record) { job }
      it { is_expected.to be_index }
    end

    context 'when user does not own the job' do
      let(:current_user) { user }
      let(:record) { other_job }
      it { is_expected.not_to be_index }
    end
  end

  describe '#destroy?' do
    subject { described_class.new(current_user, record) }

    context 'when user owns the job' do
      let(:current_user) { user }
      let(:record) { job }
      it { is_expected.to be_destroy }
    end

    context 'when user does not own the job' do
      let(:current_user) { user }
      let(:record) { other_job }
      it { is_expected.not_to be_destroy }
    end
  end

  describe '#owned?' do
    subject { described_class.new(user, record) }

    context 'when user owns the job' do
      let(:record) { job }
      it { is_expected.to be_owned }
    end

    context 'when user does not own the job' do
      let(:record) { other_job }
      it { is_expected.not_to be_owned }
    end
  end

  describe 'Scope' do
    it 'returns only jobs owned by the user' do
      job # owned
      other_job # not owned
      scope = described_class::Scope.new(user, Job.all).resolve
      expect(scope).to contain_exactly(job)
    end
  end
end
