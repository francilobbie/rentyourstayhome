class AddCountryCodeToFlats < ActiveRecord::Migration[7.0]
  def change
    add_column :flats, :country_code, :string
  end
end
