class ChangeFlatsReviewsCountAverageRatingColumns < ActiveRecord::Migration[7.0]
  def change
    change_column :flats, :reviews_count, :integer, default: 0, null: false
    change_column :flats, :average_rating, :decimal, default: 0, null: false
  end
end
