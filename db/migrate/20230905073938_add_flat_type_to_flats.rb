class AddFlatTypeToFlats < ActiveRecord::Migration[7.0]
  def change
    add_column :flats, :flat_type, :string
  end
end
