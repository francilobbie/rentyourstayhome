class AddZipCodeToFlats < ActiveRecord::Migration[7.0]
  def change
    add_column :flats, :zip_code, :string
  end
end
