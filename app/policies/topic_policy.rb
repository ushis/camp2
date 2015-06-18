class TopicPolicy < ApplicationPolicy
  def show?
    record.users.include?(user)
  end

  def create?
    true
  end

  def update?
    record.users.include?(user)
  end

  def destroy?
    record.users.include?(user)
  end

  def permitted_attributes
    %i(name list_positions)
  end

  def accessible_attributes
    %i(id name shares_count invitations_count lists_count created_at updated_at)
  end
end
