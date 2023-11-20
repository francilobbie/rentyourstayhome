class Review < ApplicationRecord

  belongs_to :user
  belongs_to :reviewable, polymorphic: true, counter_cache: true

  validates :title, presence: true
  validates :description, presence: true
  validates :rating, presence: true, numericality: { only_integer: true }, inclusion: { in: (0..5) }

  after_commit :update_average_rating, on: [:create, :update, :destroy]

  def update_average_rating
    average = reviewable.reviews.average(:rating)
    reviewable.update!(average_rating: average || 0.0)
  end


end
