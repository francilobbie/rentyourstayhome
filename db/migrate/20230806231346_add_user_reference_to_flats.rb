class AddUserReferenceToFlats < ActiveRecord::Migration[7.0]
  def change
    add_reference :flats, :user, null: false, foreign_key: true

    # Flat.update_all(user_id: User.first.id)
  end
end
