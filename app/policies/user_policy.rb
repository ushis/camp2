class UserPolicy < ApplicationPolicy
  def show?
    record == user
  end

  def create?
    true
  end

  def update?
    record == user
  end

  def destroy?
    record == user
  end

  def permitted_attributes
    %i(name email password password_confirmation)
  end

  def accessible_attributes
    if record == user
      %i(id name email access_token created_at updated_at)
    else
      %i(id name)
    end
  end
end
