class UserPolicy < ApplicationPolicy
  def create?
    @user.id == record.id
  end

  def show?
    @user.id == @record.id
  end

  def update?
    @user.id == @record.id
  end
end
