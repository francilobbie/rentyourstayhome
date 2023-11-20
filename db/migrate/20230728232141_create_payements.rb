class CreatePayements < ActiveRecord::Migration[7.0]
  def change
    create_table :payements do |t|
      t.references :booking, null: false, foreign_key: true

      t.timestamps
    end
  end
end
