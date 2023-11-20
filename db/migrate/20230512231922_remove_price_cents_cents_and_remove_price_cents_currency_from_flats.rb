class RemovePriceCentsCentsAndRemovePriceCentsCurrencyFromFlats < ActiveRecord::Migration[7.0]
  def change
    remove_column :flats, :price_cents_cents, :integer
    remove_column :flats, :price_cents_currency, :string
  end
end
