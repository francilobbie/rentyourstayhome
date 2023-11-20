class Host::PayementsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize current_user, policy_class: HostPolicy
    @payements = current_user.receiving_payements
  end
end
