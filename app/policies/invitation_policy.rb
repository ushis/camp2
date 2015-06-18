class InvitationPolicy < ApplicationPolicy
  def show?
    record.topic.users.include?(user)
  end

  def create?
    record.topic.users.include?(user)
  end

  def destroy?
    record.topic.users.include?(user)
  end

  def permitted_attributes
    %i(email)
  end

  def accessible_attributes
    %i(id email expired created_at updated_at)
  end
end
