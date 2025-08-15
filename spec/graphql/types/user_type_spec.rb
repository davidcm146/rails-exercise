# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::UserType, type: :graphql do # rubocop:disable Metrics/BlockLength
  subject { described_class }
  it { is_expected.to be < GraphQL::Schema::Object }

  describe 'fields' do
    it 'has field id with type ID!' do
      field = subject.fields['id']
      expect(field.type.to_type_signature).to eq('ID!')
    end

    it 'has field email with type String' do
      field = subject.fields['email']
      expect(field.type.to_type_signature).to eq('String')
    end

    it 'has field full_name with type String' do
      field = subject.fields['fullName']
      expect(field.type.to_type_signature).to eq('String')
    end

    it 'has field avatar with type String' do
      field = subject.fields['avatar']
      expect(field.type.to_type_signature).to eq('String')
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
