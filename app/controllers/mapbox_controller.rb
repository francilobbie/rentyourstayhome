class MapboxController < ApplicationController
  require 'rest_client'


  def search
    query = params[:query]
    access_token = ENV['MAPBOX_API_KEY']

    # Endpoint from Mapbox's Geocoding API
    url = "https://api.mapbox.com/geocoding/v5/mapbox.places/#{CGI.escape(query)}.json?access_token=#{access_token}"

    response = RestClient.get(url)
    render json: response.body
  end
end
