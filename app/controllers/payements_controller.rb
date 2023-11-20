class PayementsController < ApplicationController
  before_action :authenticate_user!

  def index
    @payements = current_user.payements.includes(booking: :flat)
  end
end
