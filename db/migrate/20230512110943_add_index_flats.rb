class AddIndexFlats < ActiveRecord::Migration[7.0]
  def change
    add_index :flats, [:latitude, :longitude]
  end
end
