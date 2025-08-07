# frozen_string_literal: true

class JobPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def update?
    owned?
  end

  def index?
    owned?
  end

  def destroy?
    owned?
  end

  def owned?
    user.present? && user.id == record.created_by_id
  end

  class Scope < Scope
    def resolve
      scope.where(created_by: user)
    end
  end
end
