require 'rails_helper'

RSpec.describe User, type: :model do # rubocop:disable Metrics/BlockLength
  describe 'associations' do
    it { is_expected.to have_many(:jobs).with_foreign_key(:created_by_id).dependent(:destroy).inverse_of(:created_by) }
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe 'validations' do
    subject { create(:user) }
    context 'when email is required' do
      it { is_expected.to validate_presence_of(:email) }
      # it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end

    context 'when email is validate with different sides' do
      it { is_expected.to allow_value('test@example.com').for(:email) }
      it { is_expected.not_to allow_value('invalid-email').for(:email) }
    end

    context 'when full_name is required' do
      it { is_expected.to validate_presence_of(:full_name) }
    end

    context 'when password is required' do
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_length_of(:password).is_at_least(6) }
    end
  end

  describe 'password_required?' do
    context 'when create new user' do
      let(:user) { build(:user, password: nil) }
      it 'password is required' do
        expect(user.valid?).to be false
        expect(user.errors[:password]).to include("can't be blank")
      end
    end

    context 'when update and not change password' do
      let(:user) { create(:user) }
      it 'password is not required' do
        user.full_name = 'Updated Name'
        expect(user.valid?).to be true
      end
    end

    context 'when update and change password' do
      let(:user) { create(:user) }
      it 'valid password is required' do
        user.password = 'short'
        expect(user.valid?).to be false
        expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
      end
    end
  end
end
