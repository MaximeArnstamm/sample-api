class EventPolicy < ApplicationPolicy

  def create?
    @record.user.id == @user.id
  end
end
