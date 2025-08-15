require 'rails_helper'

RSpec.describe Types::UserInputType, type: :graphql do
  subject { described_class }
  it { is_expected.to be < Types::BaseInputObject }

  describe 'fields' do
    it 'has field email with type String' do
      field = subject.arguments['email']
      expect(field.type.to_type_signature).to eq('String!')
    end

    it 'has field fullname with type String' do
      field = subject.arguments['fullName']
      expect(field.type.to_type_signature).to eq('String!')
    end

    it 'has field password with type String' do
      field = subject.arguments['password']
      expect(field.type.to_type_signature).to eq('String!')
    end

    it 'has field password confirmation with type String' do
      field = subject.arguments['passwordConfirmation']
      expect(field.type.to_type_signature).to eq('String!')
    end
  end
end
