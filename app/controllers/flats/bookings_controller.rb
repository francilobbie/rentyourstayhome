# frozen_string_literal: true

module Flats
  class BookingsController < ApplicationController
    before_action :authenticate_user!

    def new
      @flat = Flat.find(params[:flat_id])
      @booking = @flat.bookings.new
      @checkin_date = new_booking_params[:checkin_date]
      @checkout_date = new_booking_params[:checkout_date]
      @subtotal = new_booking_params[:subtotal]
      @cleaning_fee = new_booking_params[:cleaning_fee]
      @service_fee = new_booking_params[:service_fee]
      @total = new_booking_params[:total]
    end

    def total_price
      # price_per_day * duration_days
      new_booking_params[:total]
    end

    def duration_days
      (@checkout_date - @checkin_date).to_i
    end

    # def create
    #   @flat = Flat.find(params[:flat_id])
    #   @booking = @flat.bookings.new(booking_params)  # assuming booking_params is a private method that whitelists the necessary params

    #   if @booking.save
    #     # After booking is saved, redirect to new review path for the booked flat
    #     redirect_to new_flat_review_path(@flat)
    #   else
    #     render :new
    #   end
    # end

    private

    def new_booking_params
      params.permit(:checkin_date, :checkout_date, :subtotal, :cleaning_fee, :service_fee, :total)
    end

  end
end
