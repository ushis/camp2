class SharePolicy < ApplicationPolicy
  def show?
    record.topic.users.include?(user)
  end

  def create?
    record.invitation.present? &&
      record.invitation.active? &&
      record.invitation.topic == record.topic &&
      record.user == user
  end

  def destroy?
    record.topic.users.include?(user)
  end

  def accessible_attributes
    %i(id created_at updated_at)
  end

  def accessible_associations
    %i(user topic)
  end
end
