# frozen_string_literal: true

class JobPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def update?
    user.present? && user.id == record.created_by_id
  end

  def index?
    update?
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope.where(created_by: user)
    end
  end
end
