class RemoveAddress1AndAddress2FromProfile < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :address_1, :string
    remove_column :profiles, :address_2, :string
  end
end
