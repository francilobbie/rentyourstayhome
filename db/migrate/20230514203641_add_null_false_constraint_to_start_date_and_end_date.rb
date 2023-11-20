class AddNullFalseConstraintToStartDateAndEndDate < ActiveRecord::Migration[7.0]
  def change
    change_column_null :bookings, :start_date, false
    change_column_null :bookings, :end_date, false
  end
end
