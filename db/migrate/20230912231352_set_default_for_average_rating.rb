class SetDefaultForAverageRating < ActiveRecord::Migration[7.0]
  def change
    change_column_default :flats, :average_rating, 0.0
  end
end
