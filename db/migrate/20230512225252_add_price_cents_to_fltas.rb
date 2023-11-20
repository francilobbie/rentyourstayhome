class AddPriceCentsToFltas < ActiveRecord::Migration[7.0]
  def change
    add_monetize :flats,
    :price_cents,
    amount: { null: true, default: nil },
    currency: { null: true, default: nil }
  end
end
