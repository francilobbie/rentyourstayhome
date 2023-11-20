class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def index
    # i want to render all the reviews that the current user has made
    @reviews = current_user.reviews
  end

  def new
    @flat = Flat.find(params[:flat_id])
    @booking = Booking.find_by(user: current_user, flat: @flat)
    @review = @flat.reviews.new
  end

  def create
    @flat = Flat.find(params[:flat_id])
    @review = Review.new(review_params)
    @review.reviewable = @flat
    @review.user = current_user

    if @review.save
      redirect_to flat_path(@flat)
    else
      puts @review.errors.full_messages  # This will print out validation errors to the logs
      @booking = Booking.find_by(user: current_user, flat: @flat)  # <-- This is just an example. Ensure @booking is set properly.
      render :new
    end
  end


  def destroy
    @review = Review.find(params[:id])
    @reviewable = @review.reviewable
    @review.destroy
    update_flat_average_rating(@reviewable)
    redirect_to flat_path(@reviewable)
  end

  private

  def review_params
    params.require(:review).permit(:title, :description, :rating)
  end

  def update_flat_average_rating(flat)
    reviews = flat.reviews
    if reviews.empty?
      flat.update(average_rating: 0.0)
    else
      total_ratings = reviews.sum(:rating)
      average = total_ratings.to_f / reviews.count
      flat.update(average_rating: average)
    end
  end
end
