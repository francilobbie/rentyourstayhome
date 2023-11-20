class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      if user.persisted?
        profile = user.build_profile(first_name: params[:user][:first_name], last_name: params[:user][:last_name])
        profile.save
      end
    end
  end
end
