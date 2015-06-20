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
      %i(name closed list_id)
    else
      %i(name closed)
    end
  end

  def accessible_attributes
    %i(id name closed comments_count created_at updated_at)
  end
end
