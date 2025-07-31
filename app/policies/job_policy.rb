class JobPolicy < ApplicationPolicy
  def update?
    user.id = record.created_by_id
  end

  def destroy?
    update?
  end
end
