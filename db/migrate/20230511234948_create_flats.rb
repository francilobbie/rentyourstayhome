class CreateFlats < ActiveRecord::Migration[7.0]
  def change
    create_table :flats do |t|
      t.string :name
      t.string :title
      t.text :description
      t.string :city
      t.string :state
      t.string :country
      t.string :address

      t.timestamps
    end
  end
end
