# frozen_string_literal: true

class Api::FavoritesController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery with: :null_session


  def index
    @favorites = current_user.favorites
    render json: serialize_data(@favorites), status: :ok
  end

  def create
    @favorite = Favorite.new(favorite_params)
    if @favorite.save
      render json: serialize_data(@favorite), status: :created
    else
      render json: { errors: @favorite.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    head :no_content
  end

  private

  def favorite_params
    params.require(:favorite).permit(:flat_id, :user_id)
  end

  def serialize_data(favorites)
    FavoriteSerializer.new(@favorite).serializable_hash[:data].as_json
  end
end
