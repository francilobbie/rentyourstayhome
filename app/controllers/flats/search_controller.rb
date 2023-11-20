class Flats::SearchController < ApplicationController

  def index
    @flats = Flat.all
    filter_by_city!
    filter_by_country_code!
    filter_by_dates!

    @markers = @flats.with_coordinates.map do |flat|
      {
        lat: flat.latitude,
        lng: flat.longitude,
        info_html: render_to_string(partial: "info", locals: { flat: flat })
      }
    end
  end

  private

  def search_params
    params.permit(:city, :country_code, :checkin_date, :checkout_date, :commit)
  end

  def filter_by_city!
    return unless search_params[:city].present?
    @flats = @flats.city(search_params[:city])
  end

  def filter_by_country_code!
    return unless search_params[:country_code].present?
    @flats = @flats.country_code(search_params[:country_code])
  end

  def filter_by_dates!
    return unless search_params[:checkin_date].present? && search_params[:checkout_date].present?
    @flats = @flats.between_dates(search_params[:checkin_date], search_params[:checkout_date])
  end
end
