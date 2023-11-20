class FavoritesController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery with: :null_session

  def index
    @favorites = current_user.favorites
  end
end
