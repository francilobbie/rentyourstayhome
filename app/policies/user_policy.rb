class UserPolicy < ApplicationPolicy

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def delete_avatar?
    # Allow only admins to delete avatars for example:
    user == record
  end
end
