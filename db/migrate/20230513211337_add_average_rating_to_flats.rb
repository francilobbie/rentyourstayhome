class AddAverageRatingToFlats < ActiveRecord::Migration[7.0]
  def change
    add_column :flats, :average_rating, :decimal
  end
end
