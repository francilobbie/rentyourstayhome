class Host::DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize current_user, policy_class: HostPolicy
    @flats = current_user.owned_flats
  end
end
