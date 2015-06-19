class ItemPolicy < ApplicationPolicy
  def show?
    record.users.include?(user)
  end

  def create?
    record.users.include?(user)
  end

  def update?
    record.users.include?(user)
  end

  def destroy?
    record.users.include?(user)
  end

  def permitted_attributes
    if record.persisted?
      %i(name list_id)
    else
      %i(name)
    end
  end

  def accessible_attributes
    %i(id name comments_count created_at updated_at)
  end
end
