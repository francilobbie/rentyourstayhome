class ProfilePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def show?
    user.profile == record
  end

  def update?
    user.profile == record
  end

  def delete_avatar?
    user == record.user
  end
end
