class AddStripeIdToPayements < ActiveRecord::Migration[7.0]
  def change
    add_column :payements, :stripe_id, :string
  end
end
