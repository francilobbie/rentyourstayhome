class Booking < ApplicationRecord
  belongs_to :flat
  belongs_to :user

  has_one :payement, dependent: :destroy

  validates :checkin_date, :checkout_date, presence: true

  scope :future_bookings, -> { where("checkin_date >= ?", Date.today).order(:checkin_date).first }
  scope :next_future_bookings, -> { where("checkin_date >= ?", Date.today).order(:checkin_date) }

end
