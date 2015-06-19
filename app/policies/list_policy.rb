class ListPolicy < ApplicationPolicy
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
    [:name, item_positions: []]
  end

  def accessible_attributes
    %i(id name items_count created_at updated_at)
  end
end
