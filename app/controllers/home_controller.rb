class HomeController < ApplicationController

  def index
    @flats = Flat.where.not(user: current_user)
  end
end
