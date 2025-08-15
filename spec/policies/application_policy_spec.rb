require 'rails_helper'

RSpec.describe ApplicationPolicy do
  let(:user) { double('User') }
  let(:record) { double('Record') }
  let(:policy) { described_class.new(user, record) }

  it 'returns false for all default actions' do
    expect(policy.index?).to eq(false)
    expect(policy.show?).to eq(false)
    expect(policy.create?).to eq(false)
    expect(policy.update?).to eq(false)
    expect(policy.destroy?).to eq(false)
  end

  describe ApplicationPolicy::Scope do
    it 'raises NoMethodError for resolve' do
      scope = described_class.new(user, double)
      expect { scope.resolve }.to raise_error(NoMethodError, /You must define #resolve/)
    end
  end
end
