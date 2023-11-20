class Flat < ApplicationRecord
  require 'httparty'
  require 'json'

  CLEENING_FEE = 5_000.freeze
  CLEENING_FEE_MONEY = Money.new(CLEENING_FEE, "EUR")
  SERVICE_FEE_PERCENTAGE = 0.08.freeze

  monetize :price_cents, allow_nil: true

  validates :name, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :address, presence: true
  # validates :images, presence: true
  # validate :must_have_at_least_five_images
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :user, presence: true
  validates :flat_type, inclusion: { in: %w(room apartment), message: "should be either 'room' or 'apartment'" }
  # validates :country_code, presence: true, unless: Proc.new { |a| a.country_code.blank? }




  before_save :set_formatted_address, if: :location_changed?
  scope :with_coordinates, -> { where.not(latitude: nil, longitude: nil) }



  def self.format_mapbox_address(address)
    # Split the address into parts based on a comma
    parts = address.split(',')

    # Check for redundancy in postal code and city
    if parts[0].include?(parts[1].strip)
      parts.delete_at(1)
    end

    # Join the cleaned parts back together
    cleaned_address = parts.join(',').strip
    cleaned_address
  end


  def self.fetch_address_from_coordinates(latitude, longitude)
    api_key = ENV['MAPBOX_API_KEY']
    base_url = "https://api.mapbox.com/geocoding/v5/mapbox.places/#{longitude},#{latitude}.json?access_token=#{api_key}"

    uri = URI(base_url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    raw_address = data.dig("features", 0, "place_name")

    return raw_address
  end


  def self.fetch_place_name_from_mapbox(address_query)
    api_key = ENV['MAPBOX_API_KEY']
    base_url = "https://api.mapbox.com/geocoding/v5/mapbox.places/#{CGI.escape(address_query)}.json?access_token=#{api_key}"

    uri = URI(base_url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    raw_address = data.dig("features", 0, "place_name")

    # Format the raw address using our method
    formatted_address = format_mapbox_address(raw_address)
    return formatted_address
  end


  has_many_attached :images, dependent: :destroy

  belongs_to :user
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :bookings, dependent: :destroy
  has_many :booked_users, through: :bookings, source: :user
  has_many :payements, through: :bookings

  scope :city, -> (city) { where("lower(city) LIKE ?", "%#{city.downcase}%") }

  scope :country_code, -> (country_code) { where("lower(country_code)LIKE ?" , "#{country_code.downcase}") }

  scope :between_dates, -> (checkin_date, checkout_date) do
    checkin = Date.strptime(checkin_date, Date::DATE_FORMATS[:fr_date])
    checkout = Date.strptime(checkout_date, Date::DATE_FORMATS[:fr_date])

    left_outer_joins(:bookings)
    .where.not("bookings.checkin_date <= ? AND bookings.checkout_date >= ?", checkout, checkin)
      .or(where(bookings: { id: nil }))
  end


  def default_image
    images.first
  end

  def second_image
    images.second
  end

  def third_image
    images.third
  end


  def fourth_image
    images.fourth
  end

  def fifth_image
    images.fifth
  end

  def must_have_at_least_five_images
    errors.add(:images, "You property must have at least 5 images") if images.count < 5
  end

  def calculate_and_update_average_rating
    if reviews.count > 0
      avg = reviews.average(:rating)
      update(average_rating: avg)
    else
      update(average_rating: 0) # or 0, depending on how you want to handle no reviews
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["address", "average_rating", "city", "country", "country_code", "created_at", "description", "flat_type", "id", "latitude", "longitude", "name", "price_cents", "price_currency", "reviews_count", "state", "title", "updated_at", "user_id", "zip_code"]
  end

  def address_by_coordinates
    result = Geocoder.search([self.latitude, self.longitude]).first

    if result
      city = result.city || "Unknown City"
      state = result.state || "Unknown State"
      country = result.country || "Unknown Country"
      "#{city}, #{state}, #{country}"
    else
      "Address not found"
    end
  end


  def address_by_coordinates_for_index
    results = Geocoder.search([self.latitude, self.longitude])

    if results.empty?
      "No location found for these coordinates."
    else
      result = results.first
      "#{result.city}, #{result.country}"
    end
  rescue StandardError => e
    "An error occurred: #{e.message}"
  end

  def address_by_coordinates_for_share
    " #{Geocoder.search([self.latitude, self.longitude]).first.city} "
  end


  def favorited_by?(user)
    return if user.nil?
    favorites.where(user_id: user.id).exists?
  end

  def booked_dates
    bookings.pluck(:checkin_date, :checkout_date).map { |checkin_date, checkout_date| { from: checkin_date, to: checkout_date } }
  end

  def next_booking
    bookings.where("checkin_date >= ?", Date.today).order(:checkin_date).first
  end

  def available_dates
    next_booking = next_booking()  # Use the new next_booking method

    date_format = '%b %d'

    if next_booking.nil?
      "#{Date.today.strftime(date_format)} - #{Date.today.end_of_year.strftime(date_format)}"
    else
      "#{Date.today.strftime(date_format)} - #{next_booking.checkin_date.strftime(date_format)}"
    end
  end

  private

  def set_formatted_address
    raw_address = Flat.fetch_address_from_coordinates(self.latitude, self.longitude)
    self.address = Flat.format_mapbox_address(raw_address)
  end

  def location_changed?
    latitude_changed? || longitude_changed?
  end

end
