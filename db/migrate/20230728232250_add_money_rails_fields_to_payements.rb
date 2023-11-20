class AddMoneyRailsFieldsToPayements < ActiveRecord::Migration[7.0]
  def change
    add_monetize :payements, :subtotal, amount: { null: true, default: nil }, currency: { null: true, default: nil }
    add_monetize :payements, :cleaning_fee, amount: { null: true, default: nil }, currency: { null: true, default: nil }
    add_monetize :payements, :service_fee, amount: { null: true, default: nil }, currency: { null: true, default: nil }
    add_monetize :payements, :total, amount: { null: true, default: nil }, currency: { null: true, default: nil }
  end
end
