require 'rails_helper'

RSpec.describe Job, type: :model do # rubocop:disable Metrics/BlockLength
  describe 'associations' do
    it { is_expected.to belong_to(:created_by).class_name('User').inverse_of(:jobs) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:salary_from) }
    it { is_expected.to validate_presence_of(:salary_to) }
  end

  describe 'enums' do
    let(:job) { create(:job) }
    it do
      is_expected.to define_enum_for(:status)
        .with_values(draft: 0, published: 1)
    end

    it 'has draft as default' do
      expect(job.status).to eq('draft')
    end
  end

  describe 'callbacks' do
    let(:job) { create(:job) }
    context 'before_create :generate_share_link' do
      it 'generates a share_link automatically' do
        expect(job.share_link).to be_present
        expect(job.share_link.length).to eq(20)
      end
    end
  end
end
