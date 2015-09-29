class EventPolicy < ApplicationPolicy

  def show?
    @record.user.id == @user.id
  end

  def create?
    @record.user.id == @user.id
  end
end
