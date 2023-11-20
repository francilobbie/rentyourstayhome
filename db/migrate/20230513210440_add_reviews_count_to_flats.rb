class AddReviewsCountToFlats < ActiveRecord::Migration[7.0]
  def change
    add_column :flats, :reviews_count, :integer
  end
end
