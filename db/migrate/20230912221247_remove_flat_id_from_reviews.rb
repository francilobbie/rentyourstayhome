class RemoveFlatIdFromReviews < ActiveRecord::Migration[7.0]
  def change
    remove_column :reviews, :flat_id, :bigint
  end
end
