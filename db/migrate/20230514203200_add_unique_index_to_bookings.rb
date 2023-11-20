class AddUniqueIndexToBookings < ActiveRecord::Migration[7.0]
  def change
    add_index :bookings, [:flat_id, :user_id, :start_date, :end_date ], unique: true, name: 'unique_booking'
  end
end
