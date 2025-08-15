require 'rails_helper'

RSpec.describe Types::JobType, type: :graphql do # rubocop:disable Metrics/BlockLength
  subject { described_class }

  it { is_expected.to be < GraphQL::Schema::Object }

  describe 'fields' do # rubocop:disable Metrics/BlockLength
    it 'has field id with type ID!' do
      field = subject.fields['id']
      expect(field.type.to_type_signature).to eq('ID!')
    end

    it 'has field title with type String' do
      field = subject.fields['title']
      expect(field.type.to_type_signature).to eq('String')
    end

    it 'has field status with type String' do
      field = subject.fields['status']
      expect(field.type.to_type_signature).to eq('String')
    end

    it 'has field published_date with type ISO8601DateTime' do
      field = subject.fields['publishedDate']
      expect(field.type.to_type_signature).to eq('ISO8601DateTime')
    end

    it 'has field share_link with type String' do
      field = subject.fields['shareLink']
      expect(field.type.to_type_signature).to eq('String')
    end

    it 'has field salary_from with type Int' do
      field = subject.fields['salaryFrom']
      expect(field.type.to_type_signature).to eq('Int')
    end

    it 'has field salary_to with type Int' do
      field = subject.fields['salaryTo']
      expect(field.type.to_type_signature).to eq('Int')
    end

    it 'has field created_by_id with type Int!' do
      field = subject.fields['createdById']
      expect(field.type.to_type_signature).to eq('Int!')
    end

    it 'has field created_at with type ISO8601DateTime!' do
      field = subject.fields['createdAt']
      expect(field.type.to_type_signature).to eq('ISO8601DateTime!')
    end

    it 'has field updated_at with type ISO8601DateTime!' do
      field = subject.fields['updatedAt']
      expect(field.type.to_type_signature).to eq('ISO8601DateTime!')
    end
  end
end
