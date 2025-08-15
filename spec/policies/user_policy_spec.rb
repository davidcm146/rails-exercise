require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class }

  let(:current_user) { create(:user) }
  let(:other_user)   { create(:user) }

  describe '#update?' do
    context 'when user is updating their own record' do
      let(:policy) { described_class.new(current_user, current_user) }
      it 'permits access' do
        expect(policy.update?).to be true
      end
    end

    context "when user tries to update another user's record" do
      let(:policy) { described_class.new(current_user, other_user) }
      it 'denies access' do
        expect(policy.update?).to be false
      end
    end

    context 'when no user is logged in' do
      let(:policy) { described_class.new(nil, current_user) }
      it 'denies access' do
        expect(policy.update?).to be false
      end
    end
  end
end
