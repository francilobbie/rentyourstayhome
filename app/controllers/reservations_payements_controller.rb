class ReservationsPayementsController < ApplicationController
  before_action :authenticate_user!


  def create
    stripe_card = Stripe::Customer.create_source(
      stripe_customer.id,
      source: params[:stripeToken]
    )
    charge = Stripe::Charge.create(
      amount: Money.from_amount(BigDecimal(payement_params[:total])).cents,
      currency: 'eur',
      customer: stripe_customer.id,
      description: "Payment for #{user.email}",
      source: stripe_card.id
    )

    reservation = Booking.create(
      flat: flat,
      user: user,
      checkin_date: Date.strptime(payement_params[:checkin_date], Date::DATE_FORMATS[:fr_date]),
      checkout_date: Date.strptime(payement_params[:checkout_date], Date::DATE_FORMATS[:fr_date]),
    )

    payement = Payement.create(
      booking: reservation,
      subtotal: Money.from_amount(BigDecimal(payement_params[:subtotal])),
      cleaning_fee: Money.from_amount(BigDecimal(payement_params[:cleaning_fee])),
      service_fee: Money.from_amount(BigDecimal(payement_params[:service_fee])),
      total: Money.from_amount(BigDecimal(payement_params[:total])),
      stripe_id: charge.id
    )

    # redirect_to flat_path(@flat), notice: "Votre réservation a bien été prise en compte"
    redirect_to new_flat_review_path(@flat)
  end

  private

  def payement_params
    params.permit(:stripeToken, :flat_id, :checkin_date, :checkout_date, :subtotal, :cleaning_fee, :service_fee, :total, :user_id)
  end

  def user
    @user ||= User.find(payement_params[:user_id])
  end

  def flat
    @flat ||= Flat.find(payement_params[:flat_id])
  end

  def stripe_customer
    @stripe_customer ||= if user.stripe_id.blank?
      customer = Stripe::Customer.create(email: user.email)
      user.update(stripe_id: customer.id)
      customer
      else
      Stripe::Customer.retrieve(user.stripe_id)
  end

  end
end
