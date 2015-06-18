class CommentPolicy < ApplicationPolicy
  def show?
    record.item.users.include?(user)
  end

  def create?
    record.item.users.include?(user)
  end

  def update?
    record.user == user &&
      record.created_at > 10.minutes.ago &&
      record.item.users.include?(user)
  end

  def destroy?
    record.user == user &&
      record.created_at > 10.minutes.ago &&
      record.item.users.include?(user)
  end

  def permitted_attributes
    %i(comment)
  end

  def accessible_attributes
    %i(id comment created_at updated_at)
  end

  def accessible_associations
    %i(user)
  end
end
